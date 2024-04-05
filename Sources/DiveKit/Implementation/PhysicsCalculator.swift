import Foundation

public class PhysicsCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension PhysicsCalculator: PhysicsCalculating {
    public func gaugePressure(at depth: Depth) throws -> Calculation<Double.Result<Units.Pressure>> {
        try gaugePressure(
            at: depth,
            orThrow: {
                error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
            })
    }
}
