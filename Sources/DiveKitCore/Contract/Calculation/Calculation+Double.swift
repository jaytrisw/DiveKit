import Foundation

package extension Calculation {
    static func double<Unit: UnitRepresentable>(
        _ value: Double,
        unit keyPath: KeyPath<Units, Unit>,
        from configuration: Configuration) -> Self where Result == Double.Result<Unit> {
            self.init(
                result: .init(value, unit: configuration.units[keyPath: keyPath]),
                configuration: configuration)
        }

    static func double<Unit: UnitRepresentable>(
        _ value: Double,
        unit: Unit,
        configuration: Configuration) -> Self where Result == Double.Result<Unit> {
            self.init(
                result: .init(value, unit: unit),
                configuration: configuration)
        }
}
