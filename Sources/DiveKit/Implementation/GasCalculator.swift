import DiveKitInternals

final public class GasCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension GasCalculator: GasCalculating {
    public func partialPressure<Gas: GasRepresentable>(
        of inputPartialPressure: PartialPressure<Gas>,
        at depth: Double,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: inputPartialPressure,
                at: depth,
                using: physicsCalculator,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                })
        }

    public func depthAirConsumption(
        for minutes: Double,
        consuming gasConsumed: Double) throws -> Calculation<Double.Result<Units.Pressure>> {
            try minutes.validate(
                with: gasConsumed,
                using: .nonNegative,
                orThrow: { 
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.time)))
                },
                otherThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.consumed)))
                })
            .map { $0.second / $0.first }
            .map { .double($0, unit: \.pressure, from: configuration) }
        }
}
