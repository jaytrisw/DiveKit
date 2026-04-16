import Foundation
import DiveKitCore
import DiveKitInternal

public extension GasCalculating where Self: ConfigurationProviding {
    /// Calculates the partial pressure of a gas from an unblended mixture at depth.
    ///
    /// This method first converts the unblended mixture into a blended state,
    /// then calculates the gas's partial pressure at the specified depth.
    ///
    /// - Parameters:
    ///   - gas: The gas whose partial pressure should be calculated.
    ///   - blend: The unblended gas mixture.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    /// - Returns: A calculation containing the partial pressure of the gas.
    /// - Throws: `Error.blend` if the blend cannot be normalized, or a
    ///   `Error` from the partial-pressure calculation.
    ///
    /// ## Formula
    ///
    /// `partial pressure = absolute pressure × fractional pressure`
    ///
    /// ```swift
    /// let result = try calculator.partialPressure(
    ///     of: Oxygen(),
    ///     blending: unblendedBlend,
    ///     at: 30,
    ///     using: physicsCalculator
    /// )
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
    /// This is a convenience wrapper that uses the receiver’s configuration
    /// to normalize gas consumption to surface conditions.
    ///
    /// - Parameters:
    ///   - depth: The depth at which gas was consumed.
    ///   - minutes: The elapsed time.
    ///   - gasConsumed: The amount of gas consumed.
    ///   - physicsCalculator: A calculator used to determine absolute pressure at depth.
    /// - Returns: A calculation containing the surface air consumption rate.
    /// - Throws: `Error.negative` for negative `depth`, `minutes`, or
    ///   `gasConsumed`, or `Error.range` when `minutes` is zero.
    ///
    /// ## Formula
    ///
    /// `SAC = depth consumption ÷ absolute pressure`
    ///
    /// ```swift
    /// let sac = try calculator.surfaceAirConsumption(
    ///     at: 30,
    ///     for: 20,
    ///     consuming: 50,
    ///     using: physicsCalculator
    /// )
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
    /// This method converts an unblended mixture into a blended state and then
    /// computes the equivalent air depth based on the nitrogen content.
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The unblended gas mixture.
    /// - Returns: A calculation containing the equivalent air depth.
    /// - Throws: `Error.blend` if the blend cannot be normalized, or
    ///   `Error.negative` if `depth` is negative.
    ///
    /// ## Formula
    ///
    /// `EAD = ((depth + pressure increase per atmosphere) × nitrogen ratio) - pressure increase per atmosphere`
    ///
    /// ```swift
    /// let ead = try calculator.equivalentAirDepth(
    ///     for: 30,
    ///     with: blend
    /// )
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
