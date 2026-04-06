import Foundation

public extension GasCalculating where Self: ConfigurationProviding {
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        blending blend: Blend<Unblended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>> {
            try blend.blend(.from(self))
                .map { (blended: Blend<Blended>) throws(DiveKit.Error) in
                    try partialPressure(
                        of: gas,
                        in: blended,
                        at: depth,
                        using: physicsCalculator,
                        with: configuration,
                        .from(self))
                }
        }

    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Pressure>>> {
            try surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: gasConsumed,
                using: physicsCalculator,
                with: configuration,
                .from(self))
        }

    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Unblended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try blend.blend(.from(self))
                .map { (blended: Blend<Blended>) throws(DiveKit.Error) in
                    try equivalentAirDepth(for: depth, with: blended)
                }
        }
}
