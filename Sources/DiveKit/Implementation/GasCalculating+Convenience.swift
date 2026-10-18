import Foundation
import DiveKitCore
import DiveKitInternal

public extension GasCalculating where Self: ConfigurationProviding {
    /// Calculates the partial pressure of a gas from an unblended mixture at depth.
    ///
    /// - Parameters:
    ///   - gas: The gas whose partial pressure should be calculated.
    ///   - blend: The unblended gas mixture.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    /// - Returns: A calculation containing the partial pressure of the gas.
    /// - Throws: `Error.blend` if the blend cannot be normalized, or the
    ///   `Error` thrown by the partial-pressure calculation.
    ///
    /// ```swift
    /// let result = try calculator.partialPressure(
    ///     of: Oxygen(),
    ///     blending: unblendedBlend,
    ///     at: 30,
    ///     using: physicsCalculator)
    /// ```
    ///
    /// - Since: 1.0.0
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        blending blend: Blend<Unblended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>> {
            try blend.blend(.from(self))
                .map { (blended: Blend<Blended>) throws(DiveKit.Error) in
                    try partialPressure(
                        of: gas,
                        in: blended,
                        at: depth,
                        using: physicsCalculator,
                        with: configuration,
                        .from(self))
                }
        }

    /// Calculates the surface air consumption (SAC) rate.
    ///
    /// This is a convenience wrapper that uses the receiver's configuration
    /// to normalize gas consumption to surface conditions.
    ///
    /// - Parameters:
    ///   - depth: The depth at which gas was consumed.
    ///   - minutes: The elapsed time.
    ///   - gasConsumed: The amount of gas consumed.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    /// - Returns: A calculation containing the surface air consumption rate.
    /// - Throws: `Error.negative` for negative `depth`, `minutes`, or
    ///   `gasConsumed`, or `Error.range` when `depth`, `minutes`,
    ///   `gasConsumed`, or the result is not finite, when `minutes` is zero, or
    ///   when the water model's pressure increase is not finite or not greater than zero.
    ///
    /// ```swift
    /// let sac = try calculator.surfaceAirConsumption(
    ///     at: 30,
    ///     for: 20,
    ///     consuming: 50,
    ///     using: physicsCalculator)
    /// ```
    ///
    /// - Since: 1.0.0
    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Pressure>>> {
            try surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: gasConsumed,
                using: physicsCalculator,
                with: configuration,
                .from(self))
        }

    /// Calculates the equivalent air depth (EAD) for a given depth and gas mixture.
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The unblended gas mixture.
    /// - Returns: A calculation containing the equivalent air depth.
    /// - Throws: `Error.blend` if the blend cannot be normalized,
    ///   `Error.negative` if `depth` is negative, or `Error.range` if `depth`
    ///   or the result is not finite, or if the water model's pressure
    ///   increase is not finite or not greater than zero.
    ///
    /// ```swift
    /// let ead = try calculator.equivalentAirDepth(
    ///     for: 30,
    ///     with: blend)
    /// ```
    ///
    /// - Since: 1.0.0
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Unblended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try blend.blend(.from(self))
                .map { (blended: Blend<Blended>) throws(DiveKit.Error) in
                    try equivalentAirDepth(for: depth, with: blended)
                }
        }
}
