import Foundation

public extension BuoyancyCalculating {
    func buoyancyOfObject(weighing weight: Mass, andDisplacing volume: Volume) throws -> Calculation<Buoyancy> {
        try weight
            .validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .buoyancyCalculator(.negative(.weight)))
                })
            .map {
                try volume.validate(
                    using: .nonNegative,
                    orThrow: {
                        error(describing: self, for: $0, with: .buoyancyCalculator(.negative(.volume)))
                    })
            }
            .map {
                try buoyancy(of: .init(weight: weight, volume: $0))
            }
    }
}
