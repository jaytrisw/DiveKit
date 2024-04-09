import Foundation

public extension GasCalculating {
    func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with tank: Tank,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalResult<Volume>> {
            try tank.validate(using: .size, orThrow: { .input(.invalid(.tank($0)), .from(self))  })
                .map { try surfaceAirConsumption(at: depth, for: minutes, consuming: gasConsumed, using: physicsCalculator, .from(self)) }
                .map { $0.result.value * tank.size.conversionFactor }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }
}

private extension Tank.Size {
    var conversionFactor: Double {
        volume.value / ratedPressure.value
    }
}
