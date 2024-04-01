import DiveKitInternals

public class PhysicsCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension PhysicsCalculator: PhysicsCalculating {
    public func gaugePressure(at depth: Double) throws -> Calculation<DoubleResult<Units.Pressure>> {
        try gaugePressure(at: depth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) })
    }
}
