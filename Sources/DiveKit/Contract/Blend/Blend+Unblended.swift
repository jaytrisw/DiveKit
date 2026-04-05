import Foundation

public enum Unblended: BlendState, Sendable {}

public extension Blend where State == Unblended {
    init() {
        self.init([:])
    }

    mutating func add<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws {
        try pressure
            .validate(
                using: .between(.zero, and: .one),
                onValidated: { storage.updateValue($0, forKey: .init(gas)) },
                orThrow: { .blend(.pressureRange(pressure, self), .from(self)) })
    }

    mutating func add<Gas: GasRepresentable>(_ partialPressure: FractionalPressure<Gas>) throws {
        try add(partialPressure.gas, pressure: partialPressure.value)
    }

    mutating func fill<Gas: GasRepresentable>(with gas: Gas) throws {
        try add(.init(of: gas, fractionalPressure: 1 - totalPressure))
    }

    @discardableResult
    func adding<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws -> Self {
        var copy = self
        try copy.add(gas, pressure: pressure)

        return copy
    }

    @discardableResult
    func adding<Gas: GasRepresentable>(_ partialPressure: FractionalPressure<Gas>) throws -> Self {
        try adding(partialPressure.gas, pressure: partialPressure.value)
    }

    @discardableResult
    func filling<Gas: GasRepresentable>(with gas: Gas) throws -> Self {
        var copy = self
        try copy.fill(with: gas)

        return copy
    }

    func blend() throws -> Blend<Blended> {
        try blend(.from(self))
    }
}
