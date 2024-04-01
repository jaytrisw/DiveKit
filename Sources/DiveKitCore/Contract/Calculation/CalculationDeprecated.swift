import Foundation

/// Represents a calculated `Value` with a specific `Unit` within a given `Configuration`.
public struct CalculationDeprecated<Value, Unit: UnitRepresentable> {
    public let value: Value
    public let unit: Unit
    public let configuration: Configuration

    package init(value: Value, unit: Unit, configuration: Configuration) {
        self.value = value
        self.unit = unit
        self.configuration = configuration
    }
}

package extension CalculationDeprecated {
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

extension CalculationDeprecated: Equatable where Value: Equatable {}

public struct Calculation<Result: CalculationResultRepresentable> {
    public let result: Result
    public let configuration: Configuration

    package init(result: Result, configuration: Configuration) {
        self.result = result
        self.configuration = configuration
    }
}

package extension Calculation {
    init<Unit: UnitRepresentable>(
        _ value: Double,
        unit keyPath: KeyPath<Units, Unit>,
        from configuration: Configuration) where Result == DoubleResult<Unit> {
            self.result = .init(value: value, unit: configuration.units[keyPath: keyPath])
            self.configuration = configuration
        }
}

extension Calculation: Equatable where Result: Equatable {}

public protocol CalculationResultRepresentable {}

public struct DoubleResult<Unit: UnitRepresentable> {
    public let value: Double
    public let unit: Unit

    package init(value: Double, unit: Unit) {
        self.value = value
        self.unit = unit
    }
}

extension DoubleResult: Equatable {}
extension DoubleResult: CalculationResultRepresentable {}
