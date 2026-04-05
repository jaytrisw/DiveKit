import Foundation

public protocol GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of partialPressure: FractionalPressure<Gas>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure>

    func bestBlend(
        for depth: Depth,
        fractionOxygen: PartialPressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Blend<Blended>>

    func equivalentAirDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws -> Calculation<DecimalResult<Depth>>

    func maximumOperatingDepth(
        for fractionOxygen: PartialPressure,
        in blend: Blend<Blended>) throws ->  Calculation<DecimalResult<Depth>>

    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure>

    func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        start startGas: Pressure,
        end endGas: Pressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalResult<Pressure>>

    func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure,
        with tank: Tank,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<DecimalResult<Volume>>
}
