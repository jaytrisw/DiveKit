import Foundation

public class PhysicsCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension PhysicsCalculator: PhysicsCalculating {
    public func gaugePressure(at depth: Depth) throws -> Calculation<DecimalResult<Pressure>> {
        try gaugePressure(at: depth, from: .from(self))
    }
}
