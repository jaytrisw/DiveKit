import Foundation

public struct FractionalPressure<Gas: GasRepresentable>: Sendable {
    public let gas: Gas
    public let fractionalPressure: Double

    @_spi(unsafe)
    public init(_ gas: Gas, fractionalPressure: Double) {
        self.gas = gas
        self.fractionalPressure = fractionalPressure
    }

    public init(of gas: Gas, fractionalPressure: Double) throws(DiveKit.Error) {
        try fractionalPressure.validate(using: .greaterThanOrEqual(to: .zero)) {
            .range(.lowerBound($0, .zero), .init(object: .init(describing: Self.self), function: #function))
        }
        try fractionalPressure.validate(using: .lessThanOrEqual(to: .one)) {
            .range(.upperBound($0, .one), .init(object: .init(describing: Self.self), function: #function))
        }

        self.gas = gas
        self.fractionalPressure = fractionalPressure
    }
}

extension FractionalPressure: Equatable {}
extension FractionalPressure: Hashable {}
extension FractionalPressure: ResultRepresentable {}
