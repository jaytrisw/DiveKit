import Foundation
import DiveKitCore

public extension FormatStyle {
    /// Creates a format style for rate values.
    ///
    /// - Parameters:
    ///   - unit: The rate unit to use.
    ///   - style: The localization style to use.
    /// - Returns: A rate format style.
    /// - Since: 1.0.0
    static func rate<Value>(
        _ unit: Rate<Value>.Unit,
        style: LocalizationStyle) -> Self
        where
        Self == DecimalUnitFormatStyle<Rate<Value>>,
        Value: DecimalUnitLocalizable,
        Value.Unit.Component == LocalizationComponent {
            .init(unit, style: style)
        }
}
