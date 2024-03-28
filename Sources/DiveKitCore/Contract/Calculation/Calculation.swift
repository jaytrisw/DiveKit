import Foundation

/// Represents a calculated `Value` with a specific `Unit` within a given `Configuration`.
public struct Calculation<Value, Unit: UnitRepresentable> {
    public let value: Value
    public let unit: Unit
    public let configuration: Configuration

    package init(value: Value, unit: Unit, configuration: Configuration) {
        self.value = value
        self.unit = unit
        self.configuration = configuration
    }
}

package extension Calculation {
    /// Initializes a new `Calculation` with the specified value and a unit derived from a key path into a given configuration.
    /// This initializer allows for initializing a calculation with units specified indirectly through a configuration's units.
    /// - Parameters:
    ///   - value: The value of the calculation.
    ///   - keyPath: A key path to the specific unit within the `Units`.
    ///   - configuration: The configuration context for the calculation, from which the unit is derived.
    init(_ value: Value, unit keyPath: KeyPath<Units, Unit>, from configuration: Configuration) {
        self.value = value
        self.unit = configuration.units[keyPath: keyPath]
        self.configuration = configuration
    }
}

extension Calculation: Equatable where Value: Equatable {}
