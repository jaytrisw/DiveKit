import Foundation

public extension GasCalculating {
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws -> Calculation<DecimalResult<Depth>> {
            try depth.validate(
                using: .nonNegative,
                orThrow: { .input(.negative(.depth($0)), .from(self)) })
            .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
            .with {
                blend.partialPressure(of: .nitrogen).fractionalPressure / Blend<Blended>.air.partialPressure(of: .nitrogen).fractionalPressure
            }
            .map { $0.first * $0.second }
            .map { $0 - configuration.water.pressure(configuration.units).increase.value }
            .map { .decimal($0, unit: \.depth, from: configuration) }
        }
    
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Unblended>) throws -> Calculation<DecimalResult<Depth>> {
            try blend.blend(from: .from(self))
                .map { try equivalentAirDepth(for: depth, with: $0) }
        }
}
