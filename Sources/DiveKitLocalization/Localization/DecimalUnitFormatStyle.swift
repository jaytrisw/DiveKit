import Foundation
import DiveKitCore

/// A format style for decimal values with localizable units.
///
/// - Since: 1.0.0
public struct DecimalUnitFormatStyle<Decimal: DecimalUnitLocalizable>: Sendable {
    /// The unit used by the format style.
    ///
    /// - Since: 1.0.0
    let unit: Decimal.Unit

    /// The localization style used by the format style.
    ///
    /// - Since: 1.0.0
    let style: LocalizationStyle

    /// Creates a decimal unit format style.
    ///
    /// - Parameters:
    ///   - unit: The unit used by the format style.
    ///   - style: The localization style used by the format style.
    /// - Since: 1.0.0
    public init(_ unit: Decimal.Unit, style: LocalizationStyle) {
        self.unit = unit
        self.style = style
    }
}

/// Allows decimal unit format styles to be used with Swift formatting APIs.
///
/// - Since: 1.0.0
extension DecimalUnitFormatStyle: FormatStyle {
    /// Formats a decimal value with the configured unit and style.
    ///
    /// - Parameter value: The value to format.
    /// - Returns: A localized formatted string.
    /// - Since: 1.0.0
    public func format(_ value: Decimal) -> String {
        value.localization(for: unit, style: style)
    }
}
