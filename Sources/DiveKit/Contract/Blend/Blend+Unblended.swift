import Foundation

public enum Unblended: BlendState, Sendable {}

public extension Blend where State == Unblended {
    init() {
        self.init([:])
    }

    mutating func add<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(DiveKit.Error) {
        try pressure
            .validate(
                using: .between(.zero, and: .one),
                onValidated: { storage.updateValue($0, forKey: .init(gas)) },
                orThrow: { .blend(.pressureRange(pressure, self), .from(self)) })
    }

    mutating func add<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(DiveKit.Error) {
        try add(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    mutating func fill<Gas: GasRepresentable>(with gas: Gas) throws(DiveKit.Error) {
        try add(.init(of: gas, fractionalPressure: 1 - totalPressure))
    }

    @discardableResult
    func adding<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(DiveKit.Error) -> Self {
        var copy = self
        try copy.add(gas, pressure: pressure)

        return copy
    }

    @discardableResult
    func adding<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(DiveKit.Error) -> Self {
        try adding(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    @discardableResult
    func filling<Gas: GasRepresentable>(with gas: Gas) throws(DiveKit.Error) -> Self {
        var copy = self
        try copy.fill(with: gas)

        return copy
    }

    func blend() throws(DiveKit.Error) -> Blend<Blended> {
        try blend(.from(self))
    }
}
