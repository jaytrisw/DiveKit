import Foundation

package extension GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of partialPressure: PartialPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        orThrow error: (Depth) -> Error<Depth>) throws -> Calculation<PartialPressure<Gas>> {
            try physicsCalculator.atmospheresAbsolute(at: depth, orThrow: error)
                .map { $0.result.decimal.value * partialPressure.fractionalPressure }
                .map { .partialPressure(partialPressure.gas, fractionalPressure: $0, configuration: configuration) }
        }

    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        orThrow error: (Depth) -> Error<Depth>) throws -> Calculation<PartialPressure<Gas>> {
            try blend.partialPressure(of: gas)
                .map { try partialPressure(
                    of: $0,
                    at: depth,
                    using: physicsCalculator,
                    orThrow: error) }
        }

    func depthAirConsumption(
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        minutesError: (Minutes) -> Error<Minutes>,
        consumedError: (Pressure) -> Error<Pressure>) throws -> Calculation<DecimalOutput<Pressure>> {
            try minutes.validate(using: .nonNegative, orThrow: {
                minutesError($0)
            })
            .map {
                try gasConsumed.validate(
                    using: .nonNegative,
                    orThrow: {
                        consumedError($0)
                    })
            }
            .map { gasConsumed.value / minutes.value }
            .map { .decimal(.init($0), unit: \.pressure, from: configuration) }
        }

    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating,
        atmospheresAbsoluteError: (Depth) -> Error<Depth>,
        minutesError: (Minutes) -> Error<Minutes>,
        consumedError: (Pressure) -> Error<Pressure>) throws -> Calculation<DecimalOutput<Pressure>> {
            try physicsCalculator.atmospheresAbsolute(
                at: depth,
                orThrow: atmospheresAbsoluteError)
            .with { try depthAirConsumption(
                for: minutes,
                consuming: gasConsumed,
                minutesError: minutesError,
                consumedError: consumedError)
            }
            .map { $0.second.result.decimal.value / $0.first.result.decimal.value }
            .map { .decimal(.init($0), unit: \.pressure, from: configuration) }
        }
}
