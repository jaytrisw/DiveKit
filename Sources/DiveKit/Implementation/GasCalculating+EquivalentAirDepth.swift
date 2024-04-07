import Foundation

public extension GasCalculating {
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws -> Calculation<DecimalOutput<Depth>> {
            try depth.validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                })
            .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
            .with {
                blend.partialPressure(of: .nitrogen).fractionalPressure / Blend<Blended>.air.partialPressure(of: .nitrogen).fractionalPressure
            }
            .map { $0.first * $0.second }
            .map { $0 - configuration.water.pressure(configuration.units).increase.value }
            .map { .decimal(.init($0), unit: \.depth, from: configuration) }
        }
    
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Unblended>) throws -> Calculation<DecimalOutput<Depth>> {
            try blend.blend(
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.blend(.totalPressure)))
                })
            .map { try equivalentAirDepth(for: depth, with: $0) }
        }
}
