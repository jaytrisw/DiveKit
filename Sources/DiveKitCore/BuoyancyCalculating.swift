import Foundation

public protocol BuoyancyCalculating {
    func buoyancy(
        of object: Object) throws(Error) -> Calculation<Buoyancy>
    func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws(Error) -> Calculation<Buoyancy>
    func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws(Error) -> Calculation<DecimalResult<Volume>>
}
