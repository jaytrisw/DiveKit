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
        minutesError: (Double) -> Error<Double>,
        consumedError: (Double) -> Error<Double>) throws -> Calculation<Double.Result<Units.Pressure>> {
            try physicsCalculator.atmospheresAbsolute(
                at: depth,
                orThrow: atmospheresAbsoluteError)
            .with { try depthAirConsumption(
                for: minutes,
                consuming: gasConsumed,
                minutesError: minutesError,
                consumedError: consumedError)
            }
            .map { $0.second.result.value / $0.first.result.value }
            .map { .double($0, unit: \.pressure, from: configuration) }
        }
}
