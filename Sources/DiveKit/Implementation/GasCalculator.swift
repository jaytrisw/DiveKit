import Foundation
import DiveKitCore
import DiveKitInternal

/// A calculator for gas-related diving calculations.
///
/// `GasCalculator` provides functionality for calculating partial pressures,
/// optimal gas blends, equivalent air depth (EAD), maximum operating depth (MOD),
/// and gas consumption metrics.
///
/// All calculations are performed using the provided configuration.
///
/// - Since: 1.0.0
final public class GasCalculator: ConfigurationProviding {

    /// The configuration used for all calculations.
    ///
    /// - Since: 1.0.0
    public let configuration: Configuration

    /// Creates a new gas calculator.
    ///
    /// - Parameter configuration: The configuration used for calculations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let calculator = GasCalculator(configuration: configuration)
    /// ```
    ///
    /// - Since: 1.0.0
    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension GasCalculator: GasCalculating {
    /// Calculates the partial pressure of a gas at a given depth.
    ///
    /// - Parameters:
    ///   - fractionalPressure: The fractional pressure of the gas.
    ///   - depth: The depth at which the calculation is performed.
    ///   - physicsCalculator: A calculator used to determine absolute pressure.
    /// - Returns: A calculation containing the partial pressure.
    /// - Throws: A `DiveKit.Error` from the underlying absolute-pressure calculation.
    ///
    /// ## Formula
    ///
    /// `partial pressure = absolute pressure × fractional pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let oxygen = try FractionalPressure(of: Oxygen(), fractionalPressure: 0.32)
    /// let pp = try calculator.partialPressure(
    ///     of: oxygen,
    ///     at: 30,
    ///     using: physicsCalculator
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    public func partialPressure<Gas: GasRepresentable>(
        of fractionalPressure: FractionalPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: fractionalPressure,
                at: depth,
                using: physicsCalculator,
                with: configuration,
                .from(self))
        }

    /// Calculates the best enriched air blend for a target partial pressure at depth.
    ///
    /// - Parameters:
    ///   - depth: The target depth.
    ///   - partialPressure: The desired oxygen partial pressure.
    ///   - physicsCalculator: A calculator used to determine absolute pressure.
    /// - Returns: A calculation containing the optimal blend.
    /// - Throws: `DiveKit.Error.negative` if `depth` or `partialPressure` is
    ///   negative, or `DiveKit.Error.range` if `partialPressure` is zero.
    ///
    /// ## Formula
    ///
    /// `oxygen fraction = desired oxygen partial pressure ÷ absolute pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let blend = try calculator.bestBlend(
    ///     for: 30,
    ///     partialPressure: 1.4,
    ///     using: physicsCalculator
    /// )
    /// ```
    ///
    /// - Note: The oxygen fraction is rounded down to two decimal places before
    ///   constructing the enriched air blend.
    /// - Since: 1.0.0
    public func bestBlend(
        for depth: Depth,
        partialPressure: PartialPressure<Oxygen>,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<Blend<Blended>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (_: Depth) throws(DiveKit.Error) in
                    try partialPressure.validate(using: .nonNegative) { .negative($0, .from(self)) }
                        .map { (partialPressure: PartialPressure<Oxygen>) throws(DiveKit.Error) in
                            try partialPressure.validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), .from(self)) }
                        }
                }
                .map { (_: PartialPressure<Oxygen>) throws(DiveKit.Error) in
                    try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, .from(self))
                }
                .map { partialPressure.value / $0.result.value }
                .map { $0 * 100 }
                .map { $0.rounded(.towardZero) }
                .map { $0 / 100 }
                .map { (fraction: Double) throws(DiveKit.Error) in
                    try .blend(.enrichedAir(fraction), configuration: configuration)
                }
        }

    /// Calculates the equivalent air depth (EAD).
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The gas mixture.
    /// - Returns: A calculation containing the equivalent air depth.
    /// - Throws: `DiveKit.Error.negative` if `depth` is negative.
    ///
    /// ## Formula
    ///
    /// `EAD = ((depth + pressure increase per atmosphere) × nitrogen ratio) - pressure increase per atmosphere`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let ead = try calculator.equivalentAirDepth(
    ///     for: 30,
    ///     with: blend
    /// )
    /// ```
    ///
    /// - Note: The nitrogen ratio is the blend's nitrogen fraction divided by
    ///   the nitrogen fraction in `Blend.air`.
    /// - Since: 1.0.0
    public func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
                .with { () throws(DiveKit.Error) in
                    try blend.fractionalPressure(of: .nitrogen).value / Blend.air.fractionalPressure(of: .nitrogen).value
                }
                .map { $0.first * $0.second }
                .map { $0 - configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: \.depth, from: configuration) }
        }

    /// Calculates the maximum operating depth (MOD) for a gas mixture.
    ///
    /// - Parameters:
    ///   - partialPressure: The maximum allowable oxygen partial pressure.
    ///   - blend: The gas mixture.
    /// - Returns: A calculation containing the maximum operating depth.
    /// - Throws: `DiveKit.Error.negative` if `partialPressure` is negative, or
    ///   `DiveKit.Error.range` if the oxygen fraction or `partialPressure` is zero.
    ///
    /// ## Formula
    ///
    /// `MOD = ((oxygen partial pressure ÷ oxygen fraction) - 1) × pressure increase per atmosphere`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let mod = try calculator.maximumOperatingDepth(
    ///     for: 1.4,
    ///     in: blend
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    public func maximumOperatingDepth(
        for partialPressure: PartialPressure<Oxygen>,
        in blend: Blend<Blended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try blend.fractionalPressure(of: .oxygen).value
                .validate(using: .greater(than: 0)) {
                    .range(.lowerBound($0, 0), .from(self))
                }
                .with { (_: Double) throws(DiveKit.Error) in
                    try partialPressure.validate(using: .nonNegative) { .negative($0, .from(self)) }
                        .map { (partialPressure: PartialPressure<Oxygen>) throws(DiveKit.Error) in
                            try partialPressure.validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), .from(self)) }
                        }
                }
                .map { $0.second.value / $0.first }
                .map { $0 - 1 }
                .map { $0 * configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: \.depth, from: configuration) }
        }

    /// Calculates the partial pressure of a gas in a blend at depth.
    ///
    /// - Parameters:
    ///   - gas: The gas.
    ///   - blend: The blended mixture.
    ///   - depth: The depth.
    ///   - physicsCalculator: A physics calculator.
    /// - Returns: A calculation containing the partial pressure.
    /// - Throws: A `DiveKit.Error` if the blend cannot produce a valid
    ///   fractional pressure for `gas`, or if the absolute-pressure calculation fails.
    ///
    /// ## Formula
    ///
    /// `partial pressure = absolute pressure × fractional pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pp = try calculator.partialPressure(
    ///     of: Oxygen(),
    ///     in: blend,
    ///     at: 30,
    ///     using: physicsCalculator
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    public func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: gas,
                in: blend,
                at: depth,
                using: physicsCalculator,
                with: configuration,
                .from(self))
        }

    /// Calculates surface air consumption (SAC) from start and end pressures.
    ///
    /// - Parameters:
    ///   - depth: The depth.
    ///   - minutes: The elapsed time.
    ///   - startGas: Starting pressure.
    ///   - endGas: Ending pressure.
    ///   - physicsCalculator: A physics calculator.
    /// - Returns: A calculation containing the SAC rate.
    /// - Throws: `DiveKit.Error.negative` if `startGas` or `endGas` is negative,
    ///   or a `DiveKit.Error` from surface air consumption validation.
    ///
    /// ## Formula
    ///
    /// `gas consumed = start pressure - end pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let sac = try calculator.surfaceAirConsumption(
    ///     at: 30,
    ///     for: 20,
    ///     start: 200,
    ///     end: 100,
    ///     using: physicsCalculator
    /// )
    /// ```
    ///
    /// - Warning: This method does not explicitly reject an end pressure greater
    ///   than the start pressure. In that case, the consumed pressure becomes
    ///   negative and is rejected by the downstream SAC calculation.
    /// - Since: 1.0.0
    public func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        start startGas: Pressure,
        end endGas: Pressure,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Pressure>>> {
            try startGas.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (_: Pressure) throws(DiveKit.Error) in
                    try endGas.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                }
                .map { startGas.value - endGas.value }
                .map { (consumedPressure: Double) throws(DiveKit.Error) in
                    try surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: .init(consumedPressure),
                        using: physicsCalculator,
                        with: configuration,
                        .from(self))
                }
        }

    /// Calculates respiratory minute volume (RMV).
    ///
    /// - Parameters:
    ///   - depth: The depth.
    ///   - minutes: The elapsed time.
    ///   - gasConsumed: Gas consumed.
    ///   - tank: The tank used.
    ///   - physicsCalculator: A physics calculator.
    /// - Returns: A calculation containing the RMV.
    /// - Throws: `DiveKit.Error.tank` if the tank volume or rated pressure is
    ///   negative, or a `DiveKit.Error` from surface air consumption validation.
    ///
    /// ## Formula
    ///
    /// `RMV = SAC × tank conversion factor`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rmv = try calculator.respiratoryMinuteVolume(
    ///     at: 30,
    ///     for: 20,
    ///     consuming: 50,
    ///     with: tank,
    ///     using: physicsCalculator
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    public func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with tank: Tank,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Volume>>> {
            try tank.size.volume.validate(using: .nonNegative, orThrow: { .tank(.volume($0, tank), .from(self)) })
                .map { (_: Volume) throws(DiveKit.Error) in
                    try tank.size.ratedPressure.validate(using: .nonNegative, orThrow: { .tank(.ratedPressure($0, tank), .from(self)) })
                }
                .map { (_: Pressure) throws(DiveKit.Error) in
                    try surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: gasConsumed,
                        using: physicsCalculator,
                        with: configuration,
                        .from(self))
                }
                .map { $0.result.value * tank.size.conversionFactor }
                .map { .decimal($0, unit: .perMinute(configuration.units.volume), configuration: configuration) }
        }
}

private extension Tank.Size {
    /// A conversion factor used to translate pressure-based gas usage into volume.
    ///
    /// This value represents the ratio between the tank's internal volume and its
    /// rated pressure, allowing conversion from pressure units to volume units.
    ///
    /// - Returns: The conversion factor as `volume ÷ rated pressure`.
    ///
    /// ## Formula
    ///
    /// `conversion factor = volume ÷ rated pressure`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let factor = tank.size.conversionFactor
    /// ```
    ///
    /// - Note: This is commonly used when converting surface air consumption (SAC)
    ///   into respiratory minute volume (RMV).
    /// - Since: 1.0.0
    var conversionFactor: Double {
        volume.value / ratedPressure.value
    }
}
