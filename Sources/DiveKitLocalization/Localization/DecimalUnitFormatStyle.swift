import Foundation
import DiveKitCore

/// A format style for decimal values with localizable units.
///
/// Use this style with decimal domain values such as ``DiveKitCore/Depth``,
/// ``DiveKitCore/Mass``, ``DiveKitCore/Pressure``, ``DiveKitCore/Volume``,
/// and ``DiveKitCore/Rate`` to format a value and unit together.
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

/// Makes decimal unit format styles usable with Swift formatting APIs.
///
/// - Since: 1.0.0
extension DecimalUnitFormatStyle: FormatStyle {
    /// Formats a decimal value with the configured unit and localization style.
    ///
    /// - Parameter value: The value to format.
    /// - Returns: A localized formatted string.
    /// - Since: 1.0.0
    public func format(_ value: Decimal) -> String {
        value.localization(for: unit, style: style)
    }
}
