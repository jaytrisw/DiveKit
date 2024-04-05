import Foundation

public extension GasCalculator {
    func maximumOperatingDepth(
        for fractionOxygen: FractionalPressure,
        in blend: Blend<Blended>) throws ->  Calculation<Double.Result<Units.Depth>> {
            try fractionOxygen.validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.fractionOxygen)))
                })
            .map { $0.value / blend.partialPressure(of: .oxygen).value }
            .map { $0 - 1 }
            .map { $0 * configuration.water.pressure(configuration.units).increase.value }
            .map {.double($0, unit: \.depth, from: configuration) }
        }
}
