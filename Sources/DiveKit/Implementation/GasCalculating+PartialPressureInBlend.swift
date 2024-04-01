import Foundation

public extension GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Double) throws -> CalculationDeprecated<PartialPressure<Gas>, Units.Pressure> {
            try blend.partialPressure(of: gas)
                .map { try partialPressure(of: $0, at: depth) }
        }

    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Unblended>,
        at depth: Double) throws -> CalculationDeprecated<PartialPressure<Gas>, Units.Pressure> {
            try blend.map { try $0.blend() }
                .map { try partialPressure(of: gas, in: $0, at: depth) }
        }
}
