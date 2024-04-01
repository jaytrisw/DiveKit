import Foundation
import DiveKitInternals

final public class GasCalculator: ConfigurationProviding {
    public let configuration: Configuration
    public let physicsCalculator: PhysicsCalculating


    public convenience init(configuration: Configuration) {
        self.init(configuration: configuration, physicsCalculator: PhysicsCalculator(configuration: configuration))
    }

    init(configuration: Configuration, physicsCalculator: PhysicsCalculating) {
        self.configuration = configuration
        self.physicsCalculator = physicsCalculator
    }
}

extension GasCalculator: GasCalculating {
    public func partialPressure<Gas: GasRepresentable>(
        of partialPressure: PartialPressure<Gas>,
        at depth: Double) throws -> Calculation<PartialPressure<Gas>, Units.Pressure> {
            try physicsCalculator
                .atmospheresAbsolute(
                    at: depth,
                    orThrow: { error(describing: self, for: $0, with: .gasCalculator(.negativeDepth)) })
                .map { $0.value * partialPressure.value }
                .map { .init(.init(partialPressure.gas, value: $0), unit: \.pressure, from: configuration) }
        }

    public func depthAirConsumption(
        for minutes: Double,
        consuming gasConsumed: Double) throws -> Calculation<Double, Units.Pressure> {
            try minutes
                .validate(
                    with: gasConsumed,
                    using: .nonNegative, 
                    orThrow: { error(describing: self, for: $0, with: .gasCalculator(.negative(.time))) }, 
                    otherThrow: { error(describing: self, for: $0, with: .gasCalculator(.negative(.consumed))) })
                .map { $0.second / $0.first }
                .map { .init($0, unit: \.pressure, from: configuration) }
        }
}

public extension GasCalculator {
    func maximumOperatingDepth(
        for fractionOxygen: Double,
        in blend: Blend<Blended>) throws ->  Calculation<Double, Units.Depth> {
            try fractionOxygen.validate(with: .nonNegative, orThrow: { fatalError($0.description) })
                .map { $0 / blend.partialPressure(of: .oxygen).value }
                .map { $0 - 1 }
                .map { $0 * configuration.water.pressure(configuration.units).increase.value }
                .map {.init($0, unit: \.depth, from: configuration) }
    }
}
