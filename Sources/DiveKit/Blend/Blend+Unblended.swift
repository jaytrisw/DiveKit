import Foundation
import DiveKitCore
import DiveKitInternal

public extension Blend where State == Unblended {
    /// Creates an empty unblended gas mixture.
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
    /// - Throws: `Error.range` if `pressure` is not finite, or `Error.blend`
    ///   if `pressure` is not within `0...1` or the blend already contains `gas`.
    ///
    /// ```swift
    /// try blend.add(.oxygen, pressure: 0.21)
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func add<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) {
        try set(gas, pressure: pressure, requiring: .absent, function: #function)
    }

    /// Adds a ``FractionalPressure`` to the blend.
    ///
    /// - Parameter fractionalPressure: The fractional pressure to add.
    /// - Throws: `Error.range` if the fractional-pressure value is not finite,
    ///   or `Error.blend` if it is not within `0...1` or the blend already
    ///   contains its gas.
    ///
    /// ```swift
    /// try blend.add(FractionalPressure(of: .oxygen, fractionalPressure: 0.21))
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func add<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) {
        try set(fractionalPressure.gas, pressure: fractionalPressure.value, requiring: .absent, function: #function)
    }

    /// Updates the fractional pressure for a gas.
    ///
    /// - Parameters:
    ///   - gas: The gas to update.
    ///   - pressure: The new fractional pressure.
    /// - Throws: `Error.range` if `pressure` is not finite, or `Error.blend`
    ///   if `pressure` is not within `0...1` or the blend does not contain `gas`.
    ///
    /// ```swift
    /// try blend.update(.oxygen, pressure: 0.32)
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func update<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) {
        try set(gas, pressure: pressure, requiring: .present, function: #function)
    }

    /// Updates the ``FractionalPressure`` in the blend.
    ///
    /// - Parameter fractionalPressure: The new fractional pressure.
    /// - Throws: `Error.range` if the fractional-pressure value is not finite,
    ///   or `Error.blend` if it is not within `0...1` or the blend does not
    ///   contain its gas.
    ///
    /// ```swift
    /// try blend.update(FractionalPressure(of: .oxygen, fractionalPressure: 0.32))
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func update<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) {
        try set(fractionalPressure.gas, pressure: fractionalPressure.value, requiring: .present, function: #function)
    }

    /// Fills the remaining fractional pressure with the specified gas.
    ///
    /// Filling with a gas the blend already contains replaces its fraction with
    /// whatever brings the blend's total to one.
    ///
    /// - Parameter gas: The gas used to fill the remaining capacity.
    /// - Throws: `Error.blend` if the remaining fractional pressure is not
    ///   within `0...1`.
    ///
    /// ```swift
    /// try blend.fill(with: .nitrogen)
    /// ```
    ///
    /// - Since: 1.0.0
    mutating func fill<Gas: GasRepresentable>(with gas: Gas) throws(Error) {
        try set(gas, pressure: remainingPressure(for: gas), requiring: .any, function: #function)
    }

    /// Returns a new blend by adding a gas.
    ///
    /// - Parameters:
    ///   - gas: The gas to add.
    ///   - pressure: The fractional pressure.
    /// - Returns: A new unblended ``Blend`` with the gas added.
    /// - Throws: `Error.range` if `pressure` is not finite, or `Error.blend`
    ///   if `pressure` is not within `0...1` or the blend already contains `gas`.
    ///
    /// ```swift
    /// let updated = try blend.adding(.oxygen, pressure: 0.21)
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func adding<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) -> Self {
        var copy = self
        try copy.set(gas, pressure: pressure, requiring: .absent, function: #function)

        return copy
    }

    /// Returns a new blend by adding a ``FractionalPressure``.
    ///
    /// - Parameter fractionalPressure: The fractional pressure to add.
    /// - Returns: A new blend with the value added.
    /// - Throws: `Error.range` if the fractional-pressure value is not finite,
    ///   or `Error.blend` if it is not within `0...1` or the blend already
    ///   contains its gas.
    ///
    /// ```swift
    /// let updated = try blend.adding(FractionalPressure(of: .oxygen, fractionalPressure: 0.21))
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func adding<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) -> Self {
        var copy = self
        try copy.set(fractionalPressure.gas, pressure: fractionalPressure.value, requiring: .absent, function: #function)

        return copy
    }

    /// Returns a new blend by updating a gas.
    ///
    /// - Parameters:
    ///   - gas: The gas to update.
    ///   - pressure: The new fractional pressure.
    /// - Returns: A new blend with the updated value.
    /// - Throws: `Error.range` if `pressure` is not finite, or `Error.blend`
    ///   if `pressure` is not within `0...1` or the blend does not contain `gas`.
    ///
    /// ```swift
    /// let updated = try blend.updating(.oxygen, pressure: 0.32)
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func updating<Gas: GasRepresentable>(_ gas: Gas, pressure: Double) throws(Error) -> Self {
        var copy = self
        try copy.set(gas, pressure: pressure, requiring: .present, function: #function)

        return copy
    }

    /// Returns a new blend by updating using a ``FractionalPressure``.
    ///
    /// - Parameter fractionalPressure: The new fractional pressure.
    /// - Returns: A new blend with the updated value.
    /// - Throws: `Error.range` if the fractional-pressure value is not finite,
    ///   or `Error.blend` if it is not within `0...1` or the blend does not
    ///   contain its gas.
    ///
    /// ```swift
    /// let updated = try blend.updating(FractionalPressure(of: .oxygen, fractionalPressure: 0.32))
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func updating<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) throws(Error) -> Self {
        var copy = self
        try copy.set(fractionalPressure.gas, pressure: fractionalPressure.value, requiring: .present, function: #function)

        return copy
    }

    /// Returns a new blend by filling the remaining capacity with a gas.
    ///
    /// Filling with a gas the blend already contains replaces its fraction with
    /// whatever brings the blend's total to one.
    ///
    /// - Parameter gas: The gas used to fill the remaining capacity.
    /// - Returns: A new blend with the remaining capacity filled.
    /// - Throws: `Error.blend` if the remaining fractional pressure is not
    ///   within `0...1`.
    ///
    /// ```swift
    /// let updated = try blend.filling(with: .nitrogen)
    /// ```
    ///
    /// - Since: 1.0.0
    @discardableResult
    func filling<Gas: GasRepresentable>(with gas: Gas) throws(Error) -> Self {
        var copy = self
        try copy.set(gas, pressure: remainingPressure(for: gas), requiring: .any, function: #function)

        return copy
    }

    /// Converts the unblended mixture into a blended state.
    ///
    /// The total fractional pressure must equal `1`, within `1e-12` to allow
    /// for floating-point rounding.
    ///
    /// - Returns: A blended gas mixture.
    /// - Throws: `Error.blend` if the mixture's `totalPressure` is not within
    ///   `1e-12` of `1`.
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
    /// The fraction that brings the total to one once `gas` is replaced.
    func remainingPressure<Gas: GasRepresentable>(for gas: Gas) -> Double {
        1 - (totalPressure - fractionalPressure(of: gas))
    }

    /// Whether a gas must already be in the blend before it is set.
    enum Presence {
        case absent
        case present
        case any
    }

    mutating func set<Gas: GasRepresentable>(
        _ gas: Gas,
        pressure: Double,
        requiring presence: Presence,
        function: StaticString) throws(Error) {
            let callSite: CallSite = .from(self, function: function)
            try pressure
                .validatedFinite(callSite)
                .validate(using: .between(.zero, and: .one)) { .blend(.pressureRange($0, self), callSite) }
            switch (presence, contains(gas)) {
                case (.absent, true): throw .blend(.gasAlreadyPresent(gas, self), callSite)
                case (.present, false): throw .blend(.gasNotPresent(gas, self), callSite)
                default: break
            }
            setFractionalPressure(pressure, for: gas)
        }
}
