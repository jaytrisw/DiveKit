import Foundation
import DiveKitCore
import DiveKitInternal

final public class GasCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension GasCalculator: GasCalculating {
    public func partialPressure<Gas: GasRepresentable>(
        of fractionalPressure: FractionalPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: fractionalPressure,
                at: depth,
                using: physicsCalculator,
                with: configuration,
                .from(self))
        }

    public func bestBlend(
        for depth: Depth,
        partialPressure: PartialPressure<Oxygen>,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<Blend<Blended>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (depth: Depth) throws(DiveKit.Error) in
                    try partialPressure.validate(using: .nonNegative) { .negative($0, .from(self)) }
                        .map { (partialPressure: PartialPressure<Oxygen>) throws(DiveKit.Error) in
                            try partialPressure.validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), .from(self)) }
                        }
                }
                .map { (partialPressure: PartialPressure<Oxygen>) throws(DiveKit.Error) in
                    try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, .from(self))
                }
                .map { partialPressure.value / $0.result.value }
                .map { $0 * 100 }
                .map { $0.rounded(.towardZero) }
                .map { $0 / 100 }
                .map { (fraction: Double) throws(DiveKit.Error) in
                    try .blend(.enrichedAir(fraction), configuration: configuration)
                }
        }

    public func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
                .with { () throws(DiveKit.Error) in
                    try blend.fractionalPressure(of: .nitrogen).value / Blend.air.fractionalPressure(of: .nitrogen).value
                }
                .map { $0.first * $0.second }
                .map { $0 - configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: \.depth, from: configuration) }
        }

    public func maximumOperatingDepth(
        for partialPressure: PartialPressure<Oxygen>,
        in blend: Blend<Blended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try blend.fractionalPressure(of: .oxygen).value
                .validate(using: .greater(than: 0)) {
                    .range(.lowerBound($0, 0), .from(self))
                }
                .with { (_: Double) throws(DiveKit.Error) in
                    try partialPressure.validate(using: .nonNegative) { .negative($0, .from(self)) }
                        .map { (partialPressure: PartialPressure<Oxygen>) throws(DiveKit.Error) in
                            try partialPressure.validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), .from(self)) }
                        }
                }
                .map { $0.second.value / $0.first }
                .map { $0 - 1 }
                .map { $0 * configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: \.depth, from: configuration) }
        }

    public func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>> {
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
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Pressure>>> {
            try startGas.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (_: Pressure) throws(DiveKit.Error) in
                    try endGas.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                }
                .map { startGas.value - endGas.value }
                .map { (consumedPressure: Double) throws(DiveKit.Error) in
                    try surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: .init(consumedPressure),
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
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Volume>>> {
            try tank.size.volume.validate(using: .nonNegative, orThrow: { .tank(.volume($0, tank), .from(self)) })
                .map { (_: Volume) throws(DiveKit.Error) in
                    try tank.size.ratedPressure.validate(using: .nonNegative, orThrow: { .tank(.ratedPressure($0, tank), .from(self)) })
                }
                .map { (_: Pressure) throws(DiveKit.Error) in
                    try surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: gasConsumed,
                        using: physicsCalculator,
                        with: configuration,
                        .from(self))
                }
                .map { $0.result.value * tank.size.conversionFactor }
                .map { .decimal($0, unit: .perMinute(configuration.units.volume), configuration: configuration) }
        }
}

private extension Tank.Size {
    var conversionFactor: Double {
        volume.value / ratedPressure.value
    }
}
