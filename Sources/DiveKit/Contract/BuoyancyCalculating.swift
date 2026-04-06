import Foundation

public protocol BuoyancyCalculating {
    func buoyancy(
        of object: Object) throws(DiveKit.Error) -> Calculation<Buoyancy>
    func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws(DiveKit.Error) -> Calculation<Buoyancy>
    func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws(DiveKit.Error) -> Calculation<DecimalResult<Volume>>
}
