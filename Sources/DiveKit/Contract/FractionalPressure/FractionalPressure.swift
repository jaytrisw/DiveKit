import Foundation

public struct FractionalPressure<Gas: GasRepresentable>: Sendable {
    public let gas: Gas
    public let value: Double

    @_spi(unsafe)
    public init(_ gas: Gas, fractionalPressure: Double) {
        self.gas = gas
        self.value = fractionalPressure
    }

    public init(of gas: Gas, fractionalPressure: Double) throws(DiveKit.Error) {
        let callSite: CallSite = .init(object: .init(describing: Self.self), function: #function)
        try fractionalPressure.validate(using: .greaterThanOrEqual(to: .zero)) {
            .negative(.fractionalPressure($0), callSite)
        }
        try fractionalPressure.validate(using: .lessThanOrEqual(to: .one)) {
            .range(.upperBound($0, .one), .init(object: .init(describing: Self.self), function: #function))
        }

        self.gas = gas
        self.value = fractionalPressure
    }
}

extension FractionalPressure: Equatable {}
extension FractionalPressure: Hashable {}
extension FractionalPressure: ResultRepresentable {}
