import Foundation

public final class BuoyancyCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension BuoyancyCalculator: BuoyancyCalculating {
    public func buoyancy(of object: Object) throws -> Calculation<Buoyancy> {
        try object.validate(
            using: .nonNegative,
            orThrow: {
                error(describing: self, for: $0, with: .buoyancyCalculator(.invalidObject))
            })
        .map {
            $0.volume.value * configuration.water.weight(configuration.units).value
        }
        .map {
            $0 - object.weight.value
        }
        .map {
            .buoyancy($0, configuration: configuration)
        }
    }
}
