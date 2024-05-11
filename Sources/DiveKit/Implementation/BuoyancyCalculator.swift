import Foundation

public final class BuoyancyCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension BuoyancyCalculator: BuoyancyCalculating {
    public func buoyancy(
        of object: Object) throws -> Calculation<Buoyancy> {
            try buoyancy(of: object, with: configuration, .from(self))
        }

    public func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws -> Calculation<Buoyancy> {
            try weight
                .validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) }) }
                .map { try buoyancy(of: .init(weight: weight, volume: $0)) }
        }

    public func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws -> Calculation<DecimalResult<Volume>> {
            try weight.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + buoyancy.buoyantForce }
                .map { $0 / configuration.water.weight(configuration.units).value }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }
}
