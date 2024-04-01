import Foundation

public struct PartialPressure<Gas: GasRepresentable> {
    public let gas: Gas
    public let value: Double

    public init(_ gas: Gas, value: Double) {
        self.gas = gas
        self.value = value
    }
}

extension PartialPressure: Equatable {}
extension PartialPressure: ResultRepresentable {}
