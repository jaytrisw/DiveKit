import Foundation

/// A calculator that performs pressure and volume physics calculations.
///
/// Conforming types report invalid domain inputs, such as negative depths or
/// volumes, by throwing ``Error``.
///
/// - Since: 1.0.0
public protocol PhysicsCalculating {
    /// Calculates gauge pressure at a depth.
    ///
    /// - Parameter depth: The depth at which to calculate gauge pressure.
    /// - Returns: A calculation containing gauge pressure.
    /// - Throws: ``Error/negative(_:_:)`` if `depth` is negative.
    /// - Since: 1.0.0
    func gaugePressure(
        at depth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>

    /// Calculates the compressed air volume at depth from a surface volume.
    ///
    /// - Parameters:
    ///   - depth: The target depth.
    ///   - volume: The volume at the surface.
    /// - Returns: A calculation containing volume at depth.
    /// - Throws: ``Error/negative(_:_:)`` if `depth` or `volume` is negative.
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
    /// - Throws: ``Error/negative(_:_:)`` if `depth` or `volume` is negative.
    /// - Since: 1.0.0
    func airVolumeToSurface(
        from depth: Depth,
        with volume: Volume) throws(Error) -> Calculation<DecimalResult<Volume>>

    /// Calculates absolute pressure at a depth.
    ///
    /// - Parameter depth: The depth at which to calculate absolute pressure.
    /// - Returns: A calculation containing absolute pressure in atmospheres.
    /// - Throws: ``Error/negative(_:_:)`` if `depth` is negative.
    /// - Since: 1.0.0
    func atmospheresAbsolute(
        at depth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>

    /// Calculates the pressure difference between two depths.
    ///
    /// - Parameters:
    ///   - firstDepth: The starting depth.
    ///   - secondDepth: The ending depth.
    /// - Returns: A calculation containing the pressure difference.
    /// - Throws: ``Error/negative(_:_:)`` if either depth is negative.
    /// - Since: 1.0.0
    func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>
}
