import DiveKitInternals

public extension GasCalculating {
    func bestBlend(
        for depth: Double,
        fractionOxygen: Double,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Blend<Blended>> {
            try fractionOxygen.validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.fractionOxygen)))
                })
            .map {
                try physicsCalculator.atmospheresAbsolute(
                    at: depth,
                    orThrow: {
                        error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                    })
            }
            .map { fractionOxygen / $0.result.value }
            .map { $0 * 100 }
            .map { $0.rounded(.towardZero) }
            .map { $0 / 100 }
            .map { .blend(.enrichedAir($0), configuration: configuration) }
        }
}
