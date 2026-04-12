import Foundation

public protocol PhysicsCalculating {
    func gaugePressure(
        at depth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>

    func airVolumeFromSurface(
        to depth: Depth,
        with volume: Volume) throws(Error) -> Calculation<DecimalResult<Volume>>

    func airVolumeToSurface(
        from depth: Depth,
        with volume: Volume) throws(Error) -> Calculation<DecimalResult<Volume>>

    func atmospheresAbsolute(
        at depth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>

    func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws(Error) -> Calculation<DecimalResult<Pressure>>
}
