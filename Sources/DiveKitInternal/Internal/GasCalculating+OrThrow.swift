import Foundation
import DiveKitCore

package extension GasCalculating {
    /// Calculates the partial pressure of a gas at a given depth from its fractional pressure.
    ///
    /// The partial pressure is the gas's fractional pressure multiplied by the
    /// absolute pressure at the specified depth.
    ///
    /// - Parameters:
    ///   - fractionalPressure: The fractional pressure of the gas in the breathing mix.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the partial pressure of the gas at `depth`.
    /// - Throws: ``DiveKitCore/Error/negative(_:_:)`` if `depth` is negative,
    ///   or ``DiveKitCore/Error/range(_:_:)`` if `depth` or the absolute
    ///   pressure is not finite, or if the water model's pressure increase is
    ///   not finite or not greater than zero.
    ///
    /// ```swift
    /// let result = try calculator.partialPressure(
    ///     of: FractionalPressure(Oxygen(), fractionalPressure: 0.32),
    ///     at: 30,
    ///     using: physicsCalculator,
    ///     with: configuration,
    ///     callSite)
    /// ```
    ///
    /// - Since: 1.0.0
    func partialPressure<Gas: GasRepresentable>(
        of fractionalPressure: FractionalPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<PartialPressure<Gas>> {
            try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, callSite)
                .map { $0.result.value * fractionalPressure.value }
                .map { .partialPressure($0, configuration: configuration) }
        }

    /// Calculates the partial pressure of a gas in a blended mix at a given depth.
    ///
    /// The gas's fractional pressure is read from `blend` and multiplied by the
    /// absolute pressure at `depth`.
    ///
    /// - Parameters:
    ///   - gas: The gas whose partial pressure should be calculated.
    ///   - blend: The blended gas mixture containing `gas`.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the partial pressure of `gas` at `depth`.
    /// - Throws: ``DiveKitCore/Error/negative(_:_:)`` if `depth` is negative,
    ///   or ``DiveKitCore/Error/range(_:_:)`` if `depth` or the absolute
    ///   pressure is not finite, or if the water model's pressure increase is
    ///   not finite or not greater than zero.
    ///
    /// ```swift
    /// let result = try calculator.partialPressure(
    ///     of: Oxygen(),
    ///     in: blend,
    ///     at: 30,
    ///     using: physicsCalculator,
    ///     with: configuration,
    ///     callSite)
    /// ```
    ///
    /// - Since: 1.0.0
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<PartialPressure<Gas>> {
            try blend.fractionalPressure(of: gas)
                .map { (fractionalPressure: Double) throws(Error) in
                    try partialPressure(
                        of: .init(gas, fractionalPressure: fractionalPressure),
                        at: depth,
                        using: physicsCalculator,
                        with: configuration,
                        callSite)
                }
        }

    /// Calculates the gas consumption rate at depth.
    ///
    /// The rate is the amount of gas consumed divided by the elapsed time, in
    /// pressure per minute.
    ///
    /// - Parameters:
    ///   - minutes: The elapsed time during which gas was consumed.
    ///   - gasConsumed: The amount of gas consumed over `minutes`.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the gas consumption rate at depth.
    /// - Throws: ``DiveKitCore/Error/negative(_:_:)`` if `minutes` or `gasConsumed` is
    ///   negative, or ``DiveKitCore/Error/range(_:_:)`` if `minutes`, `gasConsumed`,
    ///   or the result is not finite, or if `minutes` is zero.
    ///
    /// ```swift
    /// let result = try calculator.depthAirConsumption(
    ///     for: 20,
    ///     consuming: 50,
    ///     with: configuration,
    ///     callSite)
    /// ```
    ///
    /// - Important: `minutes` must be greater than zero.
    /// - Since: 1.0.0
    func depthAirConsumption(
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Rate<Pressure>>> {
            try minutes
                .validatedFiniteNonNegative(callSite)
                .validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), callSite) }
                .map { (_: Minutes) throws(Error) in
                    try gasConsumed
                        .validatedFiniteNonNegative(callSite)
                }
                .map { gasConsumed.value / minutes.value }
                .validatedFinite(callSite)
                .map { .decimal($0, unit: .perMinute(configuration.units.pressure), configuration: configuration) }
        }

    /// Calculates the surface air consumption rate for gas used at depth.
    ///
    /// The surface rate is the depth consumption rate divided by the absolute
    /// pressure at depth.
    ///
    /// - Parameters:
    ///   - depth: The depth at which the gas was consumed.
    ///   - minutes: The elapsed time during which gas was consumed.
    ///   - gasConsumed: The amount of gas consumed over `minutes`.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the surface air consumption rate.
    /// - Throws: ``DiveKitCore/Error/negative(_:_:)`` if `depth`, `minutes`, or
    ///   `gasConsumed` is negative, or ``DiveKitCore/Error/range(_:_:)`` if `minutes`
    ///   is zero, if `depth`, `minutes`, `gasConsumed`, or the result is not finite,
    ///   or if the water model's pressure increase is not finite or not greater than zero.
    ///
    /// ```swift
    /// let result = try calculator.surfaceAirConsumption(
    ///     at: 30,
    ///     for: 20,
    ///     consuming: 50,
    ///     using: physicsCalculator,
    ///     with: configuration,
    ///     callSite)
    /// ```
    ///
    /// - Since: 1.0.0
    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Rate<Pressure>>> {
            try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, callSite)
                .map { $0.result.value }
                .with { () throws(Error) in
                    try depthAirConsumption(for: minutes, consuming: gasConsumed, with: configuration, callSite).result.value
                }
                .map { $0.second / $0.first }
                .map { .decimal($0, unit: .perMinute(configuration.units.pressure), configuration: configuration) }
        }
}
