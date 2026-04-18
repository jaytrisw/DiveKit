import Foundation
import DiveKitCore

package extension Calculation {
    /// Creates a decimal calculation using a unit from the active configuration.
    ///
    /// This factory wraps a raw ``Swift/Double`` in a ``DiveKitCore/DecimalResult`` and stores the
    /// configuration used to produce it.
    ///
    /// - Parameters:
    ///   - value: The numeric result of the calculation.
    ///   - keyPath: A key path to the configured unit for `Value`.
    ///   - configuration: The configuration used by the calculation.
    /// - Returns: A calculation whose result is a ``DiveKitCore/DecimalResult``.
    ///
    /// ```swift
    /// let calculation: Calculation<DecimalResult<Depth>> = .decimal(
    ///     30,
    ///     unit: \.depth,
    ///     from: configuration
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    static func decimal<Value: DecimalResultRepresentable>(
        _ value: Double,
        unit keyPath: KeyPath<Units, Value.Unit>,
        from configuration: Configuration) -> Self where Result == DecimalResult<Value> {
            self.init(
                result: .init(value, unit: configuration.units[keyPath: keyPath]),
                configuration: configuration)
        }

    /// Creates a decimal calculation using an explicit unit.
    ///
    /// Use this overload when the result unit is known directly instead of
    /// being read from ``DiveKitCore/Configuration/units``.
    ///
    /// - Parameters:
    ///   - value: The numeric result of the calculation.
    ///   - unit: The unit to attach to the decimal result.
    ///   - configuration: The configuration used by the calculation.
    /// - Returns: A calculation whose result is a ``DiveKitCore/DecimalResult``.
    ///
    /// ```swift
    /// let calculation: Calculation<DecimalResult<Rate<Pressure>>> = .decimal(
    ///     18,
    ///     unit: .perMinute(configuration.units.pressure),
    ///     configuration: configuration
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    static func decimal<Value: DecimalResultRepresentable>(
        _ value: Double,
        unit: Value.Unit,
        configuration: Configuration) -> Self where Result == DecimalResult<Value> {
            self.init(
                result: .init(value, unit: unit),
                configuration: configuration)
        }
}
