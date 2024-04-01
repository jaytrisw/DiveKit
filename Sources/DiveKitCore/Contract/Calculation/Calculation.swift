import Foundation

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
