import Foundation

/// A calculator that performs pressure and volume physics calculations.
///
/// Conforming implementations throw `DiveKitCore.Error` for invalid domain
/// inputs, such as negative depths or volumes.
///
/// - Since: 1.0.0
public protocol PhysicsCalculating {
    /// Calculates gauge pressure at a depth.
    ///
    /// - Parameter depth: The depth at which to calculate gauge pressure.
    /// - Returns: A calculation containing gauge pressure.
    /// - Throws: `DiveKitCore.Error.negative` if `depth` is negative.
    /// - Since: 1.0.0
    func gaugePressure(
        at depth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>

    /// Calculates the compressed air volume at depth from a surface volume.
    ///
    /// - Parameters:
    ///   - depth: The target depth.
    ///   - volume: The volume at the surface.
    /// - Returns: A calculation containing volume at depth.
    /// - Throws: `DiveKitCore.Error.negative` for invalid negative inputs.
    /// - Since: 1.0.0
    func airVolumeFromSurface(
        to depth: Depth,
        with volume: Volume) throws(Error) -> Calculation<DecimalResult<Volume>>

    /// Calculates the surface-equivalent volume from a volume at depth.
    ///
    /// - Parameters:
    ///   - depth: The starting depth.
    ///   - volume: The volume at depth.
    /// - Returns: A calculation containing surface-equivalent volume.
    /// - Throws: `DiveKitCore.Error.negative` for invalid negative inputs.
    /// - Since: 1.0.0
    func airVolumeToSurface(
        from depth: Depth,
        with volume: Volume) throws(Error) -> Calculation<DecimalResult<Volume>>

    /// Calculates absolute pressure at a depth.
    ///
    /// - Parameter depth: The depth at which to calculate absolute pressure.
    /// - Returns: A calculation containing absolute pressure in atmospheres.
    /// - Throws: `DiveKitCore.Error.negative` if `depth` is negative.
    /// - Since: 1.0.0
    func atmospheresAbsolute(
        at depth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>

    /// Calculates the pressure difference between two depths.
    ///
    /// - Parameters:
    ///   - firstDepth: The starting depth.
    ///   - secondDepth: The ending depth.
    /// - Returns: A calculation containing the pressure difference.
    /// - Throws: `DiveKitCore.Error.negative` if either depth is negative.
    /// - Since: 1.0.0
    func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>
}
