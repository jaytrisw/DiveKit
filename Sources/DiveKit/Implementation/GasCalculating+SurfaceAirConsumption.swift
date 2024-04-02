import DiveKitInternals

public extension GasCalculating {
    func surfaceAirConsumption(
        at depth: Double,
        for minutes: Double,
        consuming gasConsumed: Double,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Double.Result<Units.Pressure>> {
            try surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: gasConsumed,
                using: physicsCalculator,
                atmospheresAbsoluteError: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                },
                minutesError: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.time)))
                },
                consumedError: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.consumed)))
                })
        }

    func surfaceAirConsumption(
        at depth: Double,
        for minutes: Double,
        start startGas: Double,
        end endGas: Double,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Double.Result<Units.Pressure>> {
            try startGas.validate(
                with: endGas,
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.startPressure)))
                },
                otherThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.endPressure)))
                })
            .map { $0.first - $0.second }
            .map {
                try surfaceAirConsumption(
                    at: depth,
                    for: minutes,
                    consuming: $0,
                    using: physicsCalculator,
                    atmospheresAbsoluteError: {
                        error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                    },
                    minutesError: {
                        error(describing: self, for: $0, with: .gasCalculator(.negative(.time)))
                    },
                    consumedError: {
                        error(describing: self, for: $0, with: .gasCalculator(.negative(.consumed)))
                    })
            }
        }
}
