import Foundation

/// A calculator that performs gas planning and gas consumption calculations.
///
/// Conforming implementations throw `DiveKitCore.Error` for invalid domain
/// inputs, blend validation failures, and range violations.
///
/// - Since: 1.0.0
public protocol GasCalculating {
    /// Calculates partial pressure from a gas fractional pressure at depth.
    ///
    /// - Parameters:
    ///   - fractionalPressure: The gas fraction to evaluate.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: The physics calculator used for absolute pressure.
    /// - Returns: A calculation containing gas partial pressure.
    /// - Throws: A `DiveKitCore.Error` from the underlying pressure calculation.
    /// - Since: 1.0.0
    func partialPressure<Gas: GasRepresentable>(
        of fractionalPressure: FractionalPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(Error) -> Calculation<PartialPressure<Gas>>

    /// Calculates the best enriched-air blend for a target oxygen partial pressure.
    ///
    /// - Parameters:
    ///   - depth: The target depth.
    ///   - partialPressure: The target oxygen partial pressure.
    ///   - physicsCalculator: The physics calculator used for absolute pressure.
    /// - Returns: A calculation containing the resulting validated blend.
    /// - Throws: `DiveKitCore.Error` for invalid depth, partial pressure, or blend range.
    /// - Since: 1.0.0
    func bestBlend(
        for depth: Depth,
        partialPressure: PartialPressure<Oxygen>,
        using physicsCalculator: PhysicsCalculating) throws(Error) -> Calculation<Blend<Blended>>

    /// Calculates equivalent air depth for a validated gas blend.
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The validated blend.
    /// - Returns: A calculation containing equivalent air depth.
    /// - Throws: `DiveKitCore.Error.negative` if `depth` is negative.
    /// - Since: 1.0.0
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws(Error) -> Calculation<DecimalResult<Depth>>

    /// Calculates maximum operating depth for a validated gas blend.
    ///
    /// - Parameters:
    ///   - partialPressure: The maximum allowed oxygen partial pressure.
    ///   - blend: The validated blend.
    /// - Returns: A calculation containing maximum operating depth.
    /// - Throws: `DiveKitCore.Error` for invalid oxygen fraction or partial pressure.
    /// - Since: 1.0.0
    func maximumOperatingDepth(
        for partialPressure: PartialPressure<Oxygen>,
        in blend: Blend<Blended>) throws(Error) -> Calculation<DecimalResult<Depth>>

    /// Calculates partial pressure for a gas contained in a validated blend.
    ///
    /// - Parameters:
    ///   - gas: The gas to evaluate.
    ///   - blend: The validated blend.
    ///   - depth: The depth at which to calculate partial pressure.
    ///   - physicsCalculator: The physics calculator used for absolute pressure.
    /// - Returns: A calculation containing gas partial pressure.
    /// - Throws: `DiveKitCore.Error` for invalid blend or pressure inputs.
    /// - Since: 1.0.0
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(Error) -> Calculation<PartialPressure<Gas>>

    /// Calculates surface air consumption from start and end pressures.
    ///
    /// - Parameters:
    ///   - depth: The depth at which gas was consumed.
    ///   - minutes: The elapsed time.
    ///   - startGas: The starting tank pressure.
    ///   - endGas: The ending tank pressure.
    ///   - physicsCalculator: The physics calculator used for absolute pressure.
    /// - Returns: A calculation containing surface air consumption.
    /// - Throws: `DiveKitCore.Error` for invalid pressure, depth, or time inputs.
    /// - Since: 1.0.0
    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        start startGas: Pressure,
        end endGas: Pressure,
        using physicsCalculator: PhysicsCalculating) throws(Error) -> Calculation<DecimalResult<Rate<Pressure>>>

    /// Calculates respiratory minute volume from gas consumed and tank size.
    ///
    /// - Parameters:
    ///   - depth: The depth at which gas was consumed.
    ///   - minutes: The elapsed time.
    ///   - gasConsumed: The consumed tank pressure.
    ///   - tank: The tank used for the dive.
    ///   - physicsCalculator: The physics calculator used for absolute pressure.
    /// - Returns: A calculation containing respiratory minute volume.
    /// - Throws: `DiveKitCore.Error` for invalid tank, pressure, depth, or time inputs.
    /// - Since: 1.0.0
    func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with tank: Tank,
        using physicsCalculator: PhysicsCalculating) throws(Error) -> Calculation<DecimalResult<Rate<Volume>>>
}
