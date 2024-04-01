import DiveKitCore

package extension GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of partialPressure: PartialPressure<Gas>,
        at depth: Double,
        using physicsCalculator: PhysicsCalculating,
        orThrow error: (Double) -> Error<Double>) throws -> Calculation<PartialPressure<Gas>> {
            try physicsCalculator.atmospheresAbsolute(at: depth, orThrow: error)
                .map { $0.result.value * partialPressure.value }
                .map { .partialPressure(partialPressure.gas, value: $0, configuration: configuration) }
        }

    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Double,
        using physicsCalculator: PhysicsCalculating,
        orThrow error: (Double) -> Error<Double>) throws -> Calculation<PartialPressure<Gas>> {
            try blend.partialPressure(of: gas)
                .map { try partialPressure(
                    of: $0,
                    at: depth,
                    using: physicsCalculator,
                    orThrow: error) }
        }
}
