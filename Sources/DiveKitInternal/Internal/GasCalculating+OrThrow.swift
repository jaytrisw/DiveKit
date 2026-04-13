import Foundation
import DiveKitCore

package extension GasCalculating {
    /// Calculates the partial pressure of a gas at a given depth from its fractional pressure.
    ///
    /// This method multiplies the gas's fractional pressure by the absolute pressure
    /// at the specified depth.
    ///
    /// - Parameters:
    ///   - fractionalPressure: The fractional pressure of the gas in the breathing mix.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the partial pressure of the gas at `depth`.
    /// - Throws: A `DiveKitCore.Error` from the underlying absolute-pressure calculation,
    ///   currently `DiveKitCore.Error.negative` when `depth` is negative.
    ///
    /// ## Formula
    ///
    /// `partial pressure = absolute pressure × fractional pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = try calculator.partialPressure(
    ///     of: FractionalPressure(Oxygen(), fractionalPressure: 0.32),
    ///     at: 30,
    ///     using: physicsCalculator,
    ///     with: configuration,
    ///     callSite
    /// )
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
    /// This method retrieves the gas's fractional pressure from `blend`, then uses it
    /// to calculate the gas's partial pressure at `depth`.
    ///
    /// - Parameters:
    ///   - gas: The gas whose partial pressure should be calculated.
    ///   - blend: The blended gas mixture containing `gas`.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the partial pressure of `gas` at `depth`.
    /// - Throws: A `DiveKitCore.Error` if the blend cannot produce a valid
    ///   fractional pressure for `gas`, or if the underlying absolute-pressure
    ///   calculation fails.
    ///
    /// ## Formula
    ///
    /// `partial pressure = absolute pressure × fractional pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = try calculator.partialPressure(
    ///     of: Oxygen(),
    ///     in: blend,
    ///     at: 30,
    ///     using: physicsCalculator,
    ///     with: configuration,
    ///     callSite
    /// )
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
    /// This method divides the amount of gas consumed by the elapsed time to produce
    /// a rate expressed as pressure per minute.
    ///
    /// - Parameters:
    ///   - minutes: The elapsed time during which gas was consumed.
    ///   - gasConsumed: The amount of gas consumed over `minutes`.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the gas consumption rate at depth.
    /// - Throws: `DiveKitCore.Error.negative` if `minutes` or `gasConsumed` is
    ///   negative, or `DiveKitCore.Error.range` if `minutes` is zero.
    ///
    /// ## Formula
    ///
    /// `depth air consumption = gas consumed ÷ time`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = try calculator.depthAirConsumption(
    ///     for: 20,
    ///     consuming: 50,
    ///     with: configuration,
    ///     callSite
    /// )
    /// ```
    ///
    /// - Important: `minutes` must be greater than zero.
    /// - Since: 1.0.0
    func depthAirConsumption(
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Rate<Pressure>>> {
            try minutes.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { (minutes: Minutes) throws(Error) in
                    try minutes.validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), callSite) }
                }
                .map { (_: Minutes) throws(Error) in
                    try gasConsumed.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                }
                .map { gasConsumed.value / minutes.value }
                .map { .decimal($0, unit: .perMinute(configuration.units.pressure), configuration: configuration) }
        }

    /// Calculates the surface air consumption rate for gas used at depth.
    ///
    /// This method normalizes gas consumption at depth to an equivalent surface rate
    /// by dividing the depth consumption rate by the absolute pressure at depth.
    ///
    /// - Parameters:
    ///   - depth: The depth at which the gas was consumed.
    ///   - minutes: The elapsed time during which gas was consumed.
    ///   - gasConsumed: The amount of gas consumed over `minutes`.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the surface air consumption rate.
    /// - Throws: A `DiveKitCore.Error` from the absolute-pressure calculation
    ///   or depth air consumption validation. This includes negative `depth`,
    ///   negative `minutes`, negative `gasConsumed`, and zero `minutes`.
    ///
    /// ## Formula
    ///
    /// `surface air consumption = depth air consumption ÷ absolute pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = try calculator.surfaceAirConsumption(
    ///     at: 30,
    ///     for: 20,
    ///     consuming: 50,
    ///     using: physicsCalculator,
    ///     with: configuration,
    ///     callSite
    /// )
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
