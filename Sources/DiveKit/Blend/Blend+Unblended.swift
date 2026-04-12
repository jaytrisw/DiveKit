import Foundation
import DiveKitCore
import DiveKitInternal

public extension Blend where State == Unblended {
    init() {
        self.init([:])
    }

    mutating func add<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) {
        try pressure.validate(using: .between(.zero, and: .one)) {
            .blend(.pressureRange($0, self), .from(self))
        }
        storage.updateValue(pressure, forKey: .init(gas))
    }

    mutating func add<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) {
        try add(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    mutating func fill<Gas: GasRepresentable>(with gas: Gas) throws(Error) {
        try add(.init(of: gas, fractionalPressure: 1 - totalPressure))
    }

    @discardableResult
    func adding<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) -> Self {
        var copy = self
        try copy.add(gas, pressure: pressure)

        return copy
    }

    @discardableResult
    func adding<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) -> Self {
        try adding(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    @discardableResult
    func filling<Gas: GasRepresentable>(with gas: Gas) throws(Error) -> Self {
        var copy = self
        try copy.fill(with: gas)

        return copy
    }

    func blend() throws(Error) -> Blend<Blended> {
        try blend(.from(self))
    }
}
