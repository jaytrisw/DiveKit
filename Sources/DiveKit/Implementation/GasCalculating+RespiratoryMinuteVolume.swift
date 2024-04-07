import Foundation

public extension GasCalculating {
    func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with tank: Tank,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalOutput<Volume>> {
            try tank.validate(
                using: .size,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.invalidTank))
                })
            .map { try surfaceAirConsumption(
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
            .map { $0.result.decimal.value * tank.size.conversionFactor }
            .map { .decimal(.init($0), unit: \.volume, from: configuration) }
        }
}

private extension Tank.Size {
    var conversionFactor: Double {
        volume.value / ratedPressure.value
    }
}
