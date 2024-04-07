import Foundation

public extension GasCalculating {
    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Double.Result<Pressure.Unit>> {
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
        at depth: Depth,
        for minutes: Minutes,
        start startGas: Pressure,
        end endGas: Pressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Double.Result<Pressure.Unit>> {
            try startGas.validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.startPressure)))
                })
            .map {
                try endGas.validate(
                    using: .nonNegative,
                    orThrow: {
                        error(describing: self, for: $0, with: .gasCalculator(.negative(.endPressure)))
                    })
            }
            .map { startGas.value - endGas.value }
            .map {
                try surfaceAirConsumption(
                    at: depth,
                    for: minutes,
                    consuming: .init($0),
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
