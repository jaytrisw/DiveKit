import Foundation

public extension GasCalculating {
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws -> Calculation<DecimalResult<Depth>> {
            try depth.validate(
                using: .nonNegative,
                orThrow: { .negative($0, .from(self)) })
            .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
            .with { blend.pressure(of: .nitrogen) / Blend.air.pressure(of: .nitrogen) }
            .map { $0.first * $0.second }
            .map { $0 - configuration.water.pressure(configuration.units).increase.value }
            .map { .decimal($0, unit: \.depth, from: configuration) }
        }
    
    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Unblended>) throws -> Calculation<DecimalResult<Depth>> {
            try blend.blend(.from(self))
                .map { try equivalentAirDepth(for: depth, with: $0) }
        }
}
