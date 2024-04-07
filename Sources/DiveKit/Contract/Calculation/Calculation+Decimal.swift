import Foundation

package extension Calculation {
    static func decimal<Value: DecimalOutputRepresentable>(
        _ value: Value,
        unit keyPath: KeyPath<Units, Value.Unit>,
        from configuration: Configuration) -> Self where Result == DecimalOutput<Value> {
            self.init(
                result: .init(value, unit: configuration.units[keyPath: keyPath]),
                configuration: configuration)
        }

    static func decimal<Value: DecimalOutputRepresentable>(
        _ value: Value,
        unit: Value.Unit,
        configuration: Configuration) -> Self where Result == DecimalOutput<Value> {
            self.init(
                result: .init(value, unit: unit),
                configuration: configuration)
        }
}
