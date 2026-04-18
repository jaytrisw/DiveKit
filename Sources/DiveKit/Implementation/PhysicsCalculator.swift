import Foundation
import DiveKitCore
import DiveKitInternal

/// A calculator for physics-based diving calculations.
///
/// `PhysicsCalculator` provides methods for calculating pressure, volume changes,
/// and relationships between depth and gas behavior based on physical laws.
///
/// All calculations are performed using the provided configuration.
///
/// - Since: 1.0.0
public class PhysicsCalculator: ConfigurationProviding {

    /// The configuration used for all calculations.
    ///
    /// - Since: 1.0.0
    public let configuration: Configuration

    /// Creates a new physics calculator.
    ///
    /// - Parameter configuration: The configuration used for calculations.
    ///
    /// ```swift
    /// let calculator = PhysicsCalculator(configuration: configuration)
    /// ```
    ///
    /// - Since: 1.0.0
    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension PhysicsCalculator: PhysicsCalculating {
    /// Calculates the gauge pressure at a given depth.
    ///
    /// - Parameter depth: The depth at which to calculate gauge pressure.
    /// - Returns: A calculation containing the gauge pressure.
    /// - Throws: `Error.negative` if `depth` is negative.
    ///
    /// ```swift
    /// let pressure = try calculator.gaugePressure(at: 30)
    /// ```
    ///
    /// - Note: Gauge pressure excludes surface atmospheric pressure.
    /// - Since: 1.0.0
    public func gaugePressure(
        at depth: Depth) throws(DiveKit.Error) -> Calculation<DecimalResult<Pressure>> {
            try gaugePressure(at: depth, with: configuration, .from(self))
        }

    /// Calculates the volume of air at depth from a known surface volume.
    ///
    /// This applies Boyle’s Law, reducing volume as pressure increases.
    ///
    /// - Parameters:
    ///   - depth: The target depth.
    ///   - volume: The volume at the surface.
    /// - Returns: A calculation containing the compressed volume at depth.
    /// - Throws: `Error.negative` if `volume` or `depth` is negative.
    ///
    /// ```swift
    /// let volumeAtDepth = try calculator.airVolumeFromSurface(
    ///     to: 30,
    ///     with: 12
    /// )
    /// ```
    ///
    /// - Note: Absolute pressure is calculated using the receiver's water and
    ///   unit configuration.
    /// - Since: 1.0.0
    public func airVolumeFromSurface(
        to depth: Depth,
        with volume: Volume) throws(DiveKit.Error) -> Calculation<DecimalResult<Volume>> {
            try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (_: Volume) throws(DiveKit.Error) in
                    try atmospheresAbsolute(at: depth, with: configuration, .from(self))
                }
                .map { volume.value / $0.result.value }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }

    /// Calculates the surface-equivalent volume of air from a given depth.
    ///
    /// This applies Boyle’s Law, increasing volume as pressure decreases.
    ///
    /// - Parameters:
    ///   - depth: The starting depth.
    ///   - volume: The volume at depth.
    /// - Returns: A calculation containing the expanded surface volume.
    /// - Throws: `Error.negative` if `volume` or `depth` is negative.
    ///
    /// ```swift
    /// let surfaceVolume = try calculator.airVolumeToSurface(
    ///     from: 30,
    ///     with: 6
    /// )
    /// ```
    ///
    /// - Note: Absolute pressure is calculated using the receiver's water and
    ///   unit configuration.
    /// - Since: 1.0.0
    public func airVolumeToSurface(
        from depth: Depth,
        with volume: Volume) throws(DiveKit.Error) -> Calculation<DecimalResult<Volume>> {
            try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (_: Volume) throws(DiveKit.Error) in
                    try atmospheresAbsolute(at: depth, with: configuration, .from(self))
                }
                .map { volume.value * $0.result.value }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }

    /// Calculates the absolute pressure (ATA) at a given depth.
    ///
    /// Absolute pressure includes both surface atmospheric pressure and the
    /// pressure exerted by the surrounding water.
    ///
    /// - Parameter depth: The depth at which to calculate pressure.
    /// - Returns: A calculation containing the absolute pressure.
    /// - Throws: `Error.negative` if `depth` is negative.
    ///
    /// ```swift
    /// let pressure = try calculator.atmospheresAbsolute(at: 30)
    /// ```
    ///
    /// - Note: The added `1` represents one atmosphere of surface pressure.
    /// - Since: 1.0.0
    public func atmospheresAbsolute(
        at depth: Depth) throws(DiveKit.Error) -> Calculation<DecimalResult<Pressure>> {
            try atmospheresAbsolute(at: depth, with: configuration, .from(self))
        }

    /// Calculates the change in pressure between two depths.
    ///
    /// - Parameters:
    ///   - firstDepth: The starting depth.
    ///   - secondDepth: The ending depth.
    /// - Returns: A calculation containing the pressure difference.
    /// - Throws: `Error.negative` if either depth is negative.
    ///
    /// ```swift
    /// let delta = try calculator.pressureChange(
    ///     from: 10,
    ///     to: 30
    /// )
    /// ```
    ///
    /// - Note: The result is negative when `secondDepth` is shallower than
    ///   `firstDepth`.
    /// - Since: 1.0.0
    public func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws(DiveKit.Error) -> Calculation<DecimalResult<Pressure>> {
            try atmospheresAbsolute(at: firstDepth, with: configuration, .from(self))
                .with { () throws(DiveKit.Error) in
                    try atmospheresAbsolute(at: secondDepth, with: configuration, .from(self))
                }
                .map { $0.second.result.value - $0.first.result.value }
                .map { .decimal($0, unit: .atmospheres, configuration: configuration) }
        }
}
