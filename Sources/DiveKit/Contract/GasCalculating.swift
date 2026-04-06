import Foundation

public protocol GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of fractionalPressure: FractionalPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>>

    func bestBlend(
        for depth: Depth,
        partialPressure: PartialPressure<Oxygen>,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<Blend<Blended>>

    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>>

    func maximumOperatingDepth(
        for partialPressure: PartialPressure<Oxygen>,
        in blend: Blend<Blended>) throws(DiveKit.Error) ->  Calculation<DecimalResult<Depth>>

    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<PartialPressure<Gas>>

    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        start startGas: Pressure,
        end endGas: Pressure,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Pressure>>>

    func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with tank: Tank,
        using physicsCalculator: PhysicsCalculating) throws(DiveKit.Error) -> Calculation<DecimalResult<Rate<Volume>>>
}
