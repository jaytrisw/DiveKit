import Foundation

public extension BuoyancyCalculating {
    func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws -> Calculation<DecimalResult<Volume>> {
            try weight.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + buoyancy.buoyantForce }
                .map { $0 / configuration.water.weight(configuration.units).value }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }
}
