import DiveKitInternals

public extension GasCalculating {
    func surfaceAirConsumption(
        at depth: Double,
        for minutes: Double,
        consuming gasConsumed: Double,
        using physicsCalculator: PhysicsCalculating) throws -> CalculationDeprecated<Double, Units.Pressure> {
            try physicsCalculator
                .atmospheresAbsolute(
                    at: depth,
                    orThrow: {
                        error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                    })
                .with { try depthAirConsumption(for: minutes, consuming: gasConsumed) }
                .map { $0.second.result.value / $0.first.result.value }
                .map { .init($0, unit: \.pressure, from: configuration) }
        }

    func surfaceAirConsumption(
        at depth: Double,
        for minutes: Double,
        start startGas: Double,
        end endGas: Double,
        using physicsCalculator: PhysicsCalculating) throws -> CalculationDeprecated<Double, Units.Pressure> {
            try startGas.validate(
                with: endGas,
                using: .nonNegative,
                orThrow: { error(describing: self, for: $0, with: .gasCalculator(.negative(.depth))) },
                otherThrow: { error(describing: self, for: $0, with: .gasCalculator(.negative(.depth))) })
            .map { $0.first - $0.second }
            .map { try surfaceAirConsumption(at: depth, for: minutes, consuming: $0, using: physicsCalculator) }
        }
}
