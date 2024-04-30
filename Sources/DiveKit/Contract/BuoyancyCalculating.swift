import Foundation

public protocol BuoyancyCalculating {
    func buoyancy(
        of object: Object) throws -> Calculation<Buoyancy>
    func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws -> Calculation<Buoyancy>
    func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws -> Calculation<DecimalResult<Volume>>
}
