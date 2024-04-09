import Foundation

public final class BuoyancyCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension BuoyancyCalculator: BuoyancyCalculating {
    public func buoyancy(of object: Object) throws -> Calculation<Buoyancy> {
        try buoyancy(of: object, .from(self))
    }
}
