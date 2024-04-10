import Foundation

public extension BuoyancyCalculating {
    func buoyancyOfObject(weighing weight: Mass, andDisplacing volume: Volume) throws -> Calculation<Buoyancy> {
        try weight
            .validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
            .map { try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) }) }
            .map { try buoyancy(of: .init(weight: weight, volume: $0)) }
    }
}
