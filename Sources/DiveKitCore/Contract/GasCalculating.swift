import Foundation

public protocol GasCalculating: ConfigurationProviding {
    func partialPressure<Gas: GasRepresentable>(
        of partialPressure: PartialPressure<Gas>,
        at depth: Double) throws -> Calculation<PartialPressure<Gas>, Units.Pressure>

    func depthAirConsumption(
        for minutes: Double,
        consuming gasConsumed: Double) throws -> Calculation<Double, Units.Pressure>
}
