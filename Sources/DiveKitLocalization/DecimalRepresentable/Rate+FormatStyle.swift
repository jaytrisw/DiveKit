import Foundation
import DiveKitCore

public extension FormatStyle {
    /// Creates a format style for rate values.
    ///
    /// - Parameters:
    ///   - unit: The rate unit to use.
    ///   - style: The localization style to use.
    ///   - locale: The locale to use, or `nil` to use the active DiveKit locale.
    ///   - precision: The precision used to format the numeric value.
    /// - Returns: A rate format style.
    /// - Since: 1.0.0
    static func rate<Value>(
        _ unit: Rate<Value>.Unit,
        style: LocalizationStyle,
        locale: Locale? = nil,
        precision: NumberFormatStyleConfiguration.Precision? = .none) -> Self
        where
        Self == DecimalUnitFormatStyle<Rate<Value>>,
        Value: DecimalUnitLocalizable,
        Value.Unit.Component == LocalizationComponent {
            .init(unit, style: style, locale: locale, precision: precision)
        }
}
