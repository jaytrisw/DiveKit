import Foundation

package extension GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of partialPressure: PartialPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        from callSite: CallSite) throws -> Calculation<PartialPressure<Gas>> {
            try physicsCalculator.atmospheresAbsolute(at: depth, from: callSite)
                .map { $0.result.value * partialPressure.fractionalPressure }
                .map { .partialPressure(partialPressure.gas, fractionalPressure: $0, configuration: configuration) }
        }

    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        from callSite: CallSite) throws -> Calculation<PartialPressure<Gas>> {
            try blend.partialPressure(of: gas)
                .map { try partialPressure(
                    of: $0,
                    at: depth,
                    using: physicsCalculator,
                    from: callSite) }
        }

    func depthAirConsumption(
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        from callSite: CallSite) throws -> Calculation<DecimalResult<Pressure>> {
            try minutes.validate(
                using: .nonNegative,
                orThrow: { .input(.negative(.minutes($0)), callSite) })
            .map { try gasConsumed.validate(
                using: .nonNegative,
                orThrow: { .input(.negative(.pressure($0)), callSite) })
            }
            .map { gasConsumed.value / minutes.value }
            .map { .decimal($0, unit: \.pressure, from: configuration) }
        }

    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating,
        from callSite: CallSite) throws -> Calculation<DecimalResult<Pressure>> {
            try physicsCalculator.atmospheresAbsolute( at: depth, from: callSite)
                .with { try depthAirConsumption(
                    for: minutes,
                    consuming: gasConsumed,
                    from: callSite)
                }
                .map { $0.second.result.value / $0.first.result.value }
                .map { .decimal($0, unit: \.pressure, from: configuration) }
        }
}
