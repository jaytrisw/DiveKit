import Foundation

public struct PartialPressure<Gas: GasRepresentable> {
    public let gas: Gas
    public let fractionalPressure: Double

    public init(_ gas: Gas, fractionalPressure: Double) {
        self.gas = gas
        self.fractionalPressure = fractionalPressure
    }
}

extension PartialPressure: Equatable {}
extension PartialPressure: Hashable {}
extension PartialPressure: ResultRepresentable {}
