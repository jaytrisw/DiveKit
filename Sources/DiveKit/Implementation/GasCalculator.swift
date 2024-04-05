import Foundation

final public class GasCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension GasCalculator: GasCalculating {
    public func partialPressure<Gas: GasRepresentable>(
        of inputPartialPressure: PartialPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: inputPartialPressure,
                at: depth,
                using: physicsCalculator,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                })
        }
}
