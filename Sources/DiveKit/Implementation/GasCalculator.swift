import Foundation

final public class GasCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension GasCalculator: GasCalculating {
    public func partialPressure<Gas: GasRepresentable>(
        of inputPartialPressure: PartialPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: inputPartialPressure,
                at: depth,
                using: physicsCalculator,
                with: configuration,
                .from(self))
        }

    public func bestBlend(
        for depth: Depth,
        fractionOxygen: FractionalPressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Blend<Blended>> {
            try fractionOxygen.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, .from(self)) }
                .map { fractionOxygen.value / $0.result.value }
                .map { $0 * 100 }
                .map { $0.rounded(.towardZero) }
                .map { $0 / 100 }
                .map { .blend(.enrichedAir($0), configuration: configuration) }
        }

    public func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws -> Calculation<DecimalResult<Depth>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
                .with { blend.pressure(of: .nitrogen) / Blend.air.pressure(of: .nitrogen) }
                .map { $0.first * $0.second }
                .map { $0 - configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: \.depth, from: configuration) }
        }

    public func maximumOperatingDepth(
        for fractionOxygen: FractionalPressure,
        in blend: Blend<Blended>) throws ->  Calculation<DecimalResult<Depth>> {
            try fractionOxygen.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value / blend.pressure(of: .oxygen) }
                .map { $0 - 1 }
                .map { $0 * configuration.water.pressure(configuration.units).increase.value }
                .map {.decimal($0, unit: \.depth, from: configuration) }
        }

    public func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: gas,
                in: blend,
                at: depth,
                using: physicsCalculator,
                with: configuration,
                .from(self))
        }

    public func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        start startGas: Pressure,
        end endGas: Pressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalResult<Pressure>> {
            try startGas.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { try endGas.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) }) }
                .map { startGas.value - endGas.value }
                .map { try surfaceAirConsumption(
                    at: depth,
                    for: minutes,
                    consuming: .init($0),
                    using: physicsCalculator,
                    with: configuration,
                    .from(self))
                }
        }

    public func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with tank: Tank,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalResult<Volume>> {
            try tank.size.volume.validate(using: .nonNegative, orThrow: { .tank(.volume($0, tank), .from(self)) })
                .map { try tank.size.ratedPressure.validate(using: .nonNegative, orThrow: { .tank(.ratedPressure($0, tank), .from(self)) })}
                .map { try surfaceAirConsumption(
                    at: depth,
                    for: minutes,
                    consuming: gasConsumed,
                    using: physicsCalculator,
                    with: configuration,
                    .from(self))
                }
                .map { $0.result.value * tank.size.conversionFactor }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }
}

private extension Tank.Size {
    var conversionFactor: Double {
        volume.value / ratedPressure.value
    }
}
