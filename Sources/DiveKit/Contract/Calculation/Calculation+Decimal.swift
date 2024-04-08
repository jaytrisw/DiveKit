import Foundation

package extension Calculation {
    static func decimal<Value: DecimalResultRepresentable>(
        _ value: Double,
        unit keyPath: KeyPath<Units, Value.Unit>,
        from configuration: Configuration) -> Self where Result == DecimalResult<Value> {
            self.init(
                result: .init(value, unit: configuration.units[keyPath: keyPath]),
                configuration: configuration)
        }

    static func decimal<Value: DecimalResultRepresentable>(
        _ value: Double,
        unit: Value.Unit,
        configuration: Configuration) -> Self where Result == DecimalResult<Value> {
            self.init(
                result: .init(value, unit: unit),
                configuration: configuration)
        }
}
