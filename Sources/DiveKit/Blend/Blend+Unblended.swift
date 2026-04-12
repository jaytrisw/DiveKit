import Foundation
import DiveKitCore
import DiveKitInternal

public extension Blend where State == Unblended {
    init() {
        self.init([:])
    }

    mutating func add<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) {
        try set(gas, pressure: pressure, function: #function)
    }

    mutating func add<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) {
        try add(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    mutating func update<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) {
        try set(gas, pressure: pressure, function: #function)
    }

    private mutating func set<Gas: GasRepresentable>(
        _ gas: Gas,
        pressure: Double,
        function: StaticString) throws(Error) {
        try pressure.validate(using: .between(.zero, and: .one)) {
            .blend(.pressureRange($0, self), .from(self, function: function))
        }
        setFractionalPressure(pressure, for: gas)
    }

    mutating func update<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) {
        try update(fractionalPressure.gas, pressure: fractionalPressure.value)
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
    func updating<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) -> Self {
        var copy = self
        try copy.update(gas, pressure: pressure)

        return copy
    }

    @discardableResult
    func updating<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) -> Self {
        try updating(fractionalPressure.gas, pressure: fractionalPressure.value)
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
