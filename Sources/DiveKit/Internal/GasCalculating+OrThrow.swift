import Foundation

internal extension GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of fractionalPressure: FractionalPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        with configuration: Configuration,
        _ callSite: CallSite) throws -> Calculation<PartialPressure<Gas>> {
            try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, callSite)
                .map { $0.result.value * fractionalPressure.value }
                .map { .partialPressure($0, configuration: configuration) }
        }

    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating,
        with configuration: Configuration,
        _ callSite: CallSite) throws -> Calculation<PartialPressure<Gas>> {
            try blend.fractionalPressure(of: gas)
                .map { try partialPressure(
                    of: $0,
                    at: depth,
                    using: physicsCalculator,
                    with: configuration,
                    callSite) }
        }

    func depthAirConsumption(
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with configuration: Configuration,
        _ callSite: CallSite) throws -> Calculation<DecimalResult<Rate<Pressure>>> {
            try minutes.validate( using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { try $0.validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), callSite) } }
                .map { try gasConsumed.validate( using: .nonNegative, orThrow: { .negative($0, callSite) }) }
                .map { gasConsumed.value / minutes.value }
                .map { .decimal($0, unit: .perMinute(configuration.units.pressure), configuration: configuration) }
        }

    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating,
        with configuration: Configuration,
        _ callSite: CallSite) throws -> Calculation<DecimalResult<Rate<Pressure>>> {
            try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, callSite)
                .map { $0.result.value }
                .with { _ in
                    try depthAirConsumption(for: minutes, consuming: gasConsumed, with: configuration, callSite).result.value
                }
                .map { $0.second / $0.first }
                .map { .decimal($0, unit: .perMinute(configuration.units.pressure), configuration: configuration) }
        }
}
