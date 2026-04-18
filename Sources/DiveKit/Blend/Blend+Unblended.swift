import Foundation
import DiveKitCore
import DiveKitInternal

public extension Blend where State == Unblended {
    /// Creates an empty unblended gas mixture.
    ///
    /// - Returns: An empty ``Blend`` in an `Unblended` state.
    ///
    /// - Since: 1.0.0
    init() {
        self.init([:])
    }

    /// Adds a gas with the specified fractional pressure.
    ///
    /// - Parameters:
    ///   - gas: The gas to add.
    ///   - pressure: The fractional pressure of the gas.
    /// - Throws: `Error.blend` if `pressure` is not within `0...1`.
    ///
    /// ```swift
    /// try blend.add(.oxygen, pressure: 0.21)
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func add<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) {
        try set(gas, pressure: pressure, function: #function)
    }

    /// Adds a ``FractionalPressure`` to the blend.
    ///
    /// - Parameter fractionalPressure: The fractional pressure to add.
    /// - Throws: `Error.blend` if the fractional pressure value is not
    ///   within `0...1`.
    ///
    /// ```swift
    /// try blend.add(FractionalPressure(of: .oxygen, fractionalPressure: 0.21))
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func add<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) {
        try add(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    /// Updates the fractional pressure for a gas.
    ///
    /// - Parameters:
    ///   - gas: The gas to update.
    ///   - pressure: The new fractional pressure.
    /// - Throws: `Error.blend` if `pressure` is not within `0...1`.
    ///
    /// ```swift
    /// try blend.update(.oxygen, pressure: 0.32)
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func update<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) {
        try set(gas, pressure: pressure, function: #function)
    }

    /// Updates the ``FractionalPressure`` in the blend.
    ///
    /// - Parameter fractionalPressure: The new fractional pressure.
    /// - Throws: `Error.blend` if the fractional pressure value is not
    ///   within `0...1`.
    ///
    /// ```swift
    /// try blend.update(FractionalPressure(of: .oxygen, fractionalPressure: 0.32))
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func update<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) {
        try update(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    /// Fills the remaining fractional pressure with the specified gas.
    ///
    /// This method calculates the remaining capacity and assigns it to `gas`.
    ///
    /// - Parameter gas: The gas used to fill the remaining capacity.
    /// - Throws: `Error.blend` if the remaining fractional pressure is
    ///   not within `0...1`.
    ///
    /// ```swift
    /// try blend.fill(with: .nitrogen)
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func fill<Gas: GasRepresentable>(with gas: Gas) throws(Error) {
        try add(.init(of: gas, fractionalPressure: 1 - totalPressure))
    }

    /// Returns a new blend by adding a gas.
    ///
    /// - Parameters:
    ///   - gas: The gas to add.
    ///   - pressure: The fractional pressure.
    /// - Returns: A new unblended ``Blend`` with the gas added.
    /// - Throws: `Error.blend` if `pressure` is not within `0...1`.
    ///
    /// ```swift
    /// let updated = try blend.adding(.oxygen, pressure: 0.21)
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func adding<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) -> Self {
        var copy = self
        try copy.add(gas, pressure: pressure)

        return copy
    }

    /// Returns a new blend by adding a ``FractionalPressure``.
    ///
    /// - Parameter fractionalPressure: The fractional pressure to add.
    /// - Returns: A new blend with the value added.
    /// - Throws: `Error.blend` if the fractional pressure value is not
    ///   within `0...1`.
    ///
    /// ```swift
    /// let updated = try blend.adding(FractionalPressure(of: .oxygen, fractionalPressure: 0.21))
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func adding<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) -> Self {
        try adding(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    /// Returns a new blend by updating a gas.
    ///
    /// - Parameters:
    ///   - gas: The gas to update.
    ///   - pressure: The new fractional pressure.
    /// - Returns: A new blend with the updated value.
    /// - Throws: `Error.blend` if `pressure` is not within `0...1`.
    ///
    /// ```swift
    /// let updated = try blend.updating(.oxygen, pressure: 0.32)
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func updating<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) -> Self {
        var copy = self
        try copy.update(gas, pressure: pressure)

        return copy
    }

    /// Returns a new blend by updating using a ``FractionalPressure``.
    ///
    /// - Parameter fractionalPressure: The new fractional pressure.
    /// - Returns: A new blend with the updated value.
    /// - Throws: `Error.blend` if the fractional pressure value is not
    ///   within `0...1`.
    ///
    /// ```swift
    /// let updated = try blend.updating(FractionalPressure(of: .oxygen, fractionalPressure: 0.32))
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func updating<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) -> Self {
        try updating(fractionalPressure.gas, pressure: fractionalPressure.value)
    }

    /// Returns a new blend by filling the remaining capacity with a gas.
    ///
    /// - Parameter gas: The gas used to fill the remaining capacity.
    /// - Returns: A new blend with the remaining capacity filled.
    /// - Throws: `Error.blend` if the remaining fractional pressure is
    ///   not within `0...1`.
    ///
    /// ```swift
    /// let updated = try blend.filling(with: .nitrogen)
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func filling<Gas: GasRepresentable>(with gas: Gas) throws(Error) -> Self {
        var copy = self
        try copy.fill(with: gas)

        return copy
    }

    /// Converts the unblended mixture into a blended state.
    ///
    /// This method validates that the total fractional pressure equals `1`
    /// before producing a blended ``Blend``.
    ///
    /// - Returns: A blended gas mixture.
    /// - Throws: `Error.blend` if the mixtures `totalPressure` is not `1`.
    ///
    /// ```swift
    /// let blended = try blend.blend()
    /// ```
    ///
    /// - Since: 1.0.0
    func blend() throws(Error) -> Blend<Blended> {
        try blend(.from(self))
    }
}

private extension Blend where State == Unblended {
    mutating func set<Gas: GasRepresentable>(
        _ gas: Gas,
        pressure: Double,
        function: StaticString) throws(Error) {
            try pressure.validate(using: .between(.zero, and: .one)) {
                .blend(.pressureRange($0, self), .from(self, function: function))
            }
            setFractionalPressure(pressure, for: gas)
        }
}
