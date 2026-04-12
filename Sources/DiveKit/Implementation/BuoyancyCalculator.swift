import Foundation
import DiveKitCore
import DiveKitInternal

public final class BuoyancyCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension BuoyancyCalculator: BuoyancyCalculating {
    public func buoyancy(
        of object: Object) throws(DiveKit.Error) -> Calculation<Buoyancy> {
            try buoyancy(of: object, with: configuration, .from(self))
        }

    public func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws(DiveKit.Error) -> Calculation<Buoyancy> {
            try weight
                .validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (mass: Mass) throws(DiveKit.Error) in
                    try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                }
                .map { (volume: Volume) throws(DiveKit.Error) in
                    try buoyancy(of: .init(weight: weight, volume: volume))
                }
        }

    public func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws(DiveKit.Error) -> Calculation<DecimalResult<Volume>> {
            try weight.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + buoyancy.buoyantForce }
                .map { $0 / configuration.water.weight(configuration.units).value }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }
}
