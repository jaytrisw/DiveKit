import DiveKitInternals

public extension GasCalculating {
    func surfaceAirConsumption(
        at depth: Double,
        for minutes: Double,
        consuming gasConsumed: Double,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Double.Result<Units.Pressure>> {
            try gasConsumed.validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.consumed)))
                })
            .map {
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
                    })
            }
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
                    })
            }
        }
}

package extension GasCalculating {
    func depthAirConsumption(
        for minutes: Double,
        consuming gasConsumed: Double,
        minutesError: (Double) -> Error<Double>,
        consumedError: (Double) -> Error<Double>) throws -> Calculation<Double.Result<Units.Pressure>> {
            try minutes.validate(
                with: gasConsumed,
                using: .nonNegative,
                orThrow: {
                    minutesError($0)
                },
                otherThrow: {
                    consumedError($0)
                })
            .map { $0.second / $0.first }
            .map { .double($0, unit: \.pressure, from: configuration) }
        }

    func surfaceAirConsumption(
        at depth: Double,
        for minutes: Double,
        consuming gasConsumed: Double,
        using physicsCalculator: PhysicsCalculating,
        atmospheresAbsoluteError: (Double) -> Error<Double>,
        minutesError: (Double) -> Error<Double>) throws -> Calculation<Double.Result<Units.Pressure>> {
            try physicsCalculator.atmospheresAbsolute(
                at: depth,
                orThrow: atmospheresAbsoluteError)
            .with { try depthAirConsumption(
                for: minutes,
                consuming: gasConsumed,
                minutesError: minutesError,
                consumedError: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.consumed)))
                })
            }
            .map { $0.second.result.value / $0.first.result.value }
            .map { .double($0, unit: \.pressure, from: configuration) }
        }
}
