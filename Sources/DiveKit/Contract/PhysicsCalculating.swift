import Foundation

public protocol PhysicsCalculating {

    /// Calculates the gauge pressure at a specified depth.
    ///
    /// Gauge pressure is the pressure relative to the ambient pressure. In many applications,
    /// it's crucial to understand how pressure changes with depth, especially in fluid dynamics
    /// and undersea or atmospheric studies.
    ///
    /// - Parameter depth: The depth at which to calculate the gauge pressure, typically measured in meters.
    /// - Returns: A `Calculation` object representing the gauge pressure at the given depth. The value
    ///   is of type `Double` and the unit is specified by `Pressure.Unit`, indicating the
    ///   pressure unit used
    /// - Throws: Can throw an error if the calculation is not possible with the provided parameters or
    ///   if the configuration is invalid or insufficient for the calculation. Implementers should specify
    ///   the conditions under which errors are thrown.
    func gaugePressure(
        at depth: Depth) throws -> Calculation<DecimalResult<Pressure>>

    func airVolumeFromSurface(
        to depth: Depth,
        with volume: Volume) throws -> Calculation<DecimalResult<Pressure>>

    func airVolumeToSurface(
        from depth: Depth,
        with volume: Volume) throws -> Calculation<DecimalResult<Pressure>>

    func atmospheresAbsolute(
        at depth: Depth) throws -> Calculation<DecimalResult<Pressure>>

    func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws -> Calculation<DecimalResult<Pressure>>
}
