import Foundation

public extension GasCalculator {
    func maximumOperatingDepth(
        for fractionOxygen: FractionalPressure,
        in blend: Blend<Blended>) throws ->  Calculation<DecimalResult<Depth>> {
            try fractionOxygen.validate(
                using: .nonNegative,
                orThrow: { .input(.negative(.fractionalPressure($0)), .from(self)) })
            .map { $0.value / blend.partialPressure(of: .oxygen).fractionalPressure }
            .map { $0 - 1 }
            .map { $0 * configuration.water.pressure(configuration.units).increase.value }
            .map {.decimal($0, unit: \.depth, from: configuration) }
        }
}
