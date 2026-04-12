import Foundation

public struct FractionalPressure<Gas: GasRepresentable>: Sendable {
    public let gas: Gas
    public let value: Double

    package init(_ gas: Gas, fractionalPressure: Double) {
        self.gas = gas
        self.value = fractionalPressure
    }
}

extension FractionalPressure: Equatable {}
extension FractionalPressure: Hashable {}
extension FractionalPressure: ResultRepresentable {}
