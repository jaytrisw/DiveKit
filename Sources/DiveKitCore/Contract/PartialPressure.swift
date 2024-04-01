import Foundation

public struct PartialPressure<Gas: GasRepresentable> {
    public let gas: Gas
    public let value: Double
    public let gaugePressure: Double

    public init(_ gas: Gas, value: Double, gaugePressure: Double = .zero) {
        self.gas = gas
        self.value = value
        self.gaugePressure = gaugePressure
    }
}

extension PartialPressure: Equatable {}
