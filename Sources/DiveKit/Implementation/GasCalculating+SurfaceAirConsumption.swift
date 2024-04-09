import Foundation

public extension GasCalculating {
    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalResult<Pressure>> {
            try surfaceAirConsumption(at: depth, for: minutes, consuming: gasConsumed, using: physicsCalculator, .from(self))
        }

    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        start startGas: Pressure,
        end endGas: Pressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalResult<Pressure>> {
            try startGas.validate(using: .nonNegative, orThrow: { .input(.negative(.pressure($0)), .from(self)) })
                .map { try endGas.validate(using: .nonNegative, orThrow: { .input(.negative(.pressure($0)), .from(self)) }) }
                .map { startGas.value - endGas.value }
                .map { try surfaceAirConsumption( at: depth, for: minutes, consuming: .init($0), using: physicsCalculator, .from(self)) }
        }
}
