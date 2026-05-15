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

    /// The locale used to localize the unit and format the numeric value.
    ///
    /// - Since: 1.0.0
    let locale: Locale

    /// The precision used to format the numeric value.
    ///
    /// - Since: 1.0.0
    let precision: NumberFormatStyleConfiguration.Precision?

    /// Creates a decimal unit format style.
    ///
    /// - Parameters:
    ///   - unit: The unit used by the format style.
    ///   - style: The localization style used by the format style.
    ///   - locale: The locale used to localize the unit and format the numeric value.
    ///   - precision: The precision used to format the numeric value.
    /// - Since: 1.0.0
    public init(
        _ unit: Decimal.Unit,
        style: LocalizationStyle,
        locale: Locale = .autoupdatingCurrent,
        precision: NumberFormatStyleConfiguration.Precision? = .none) {
        self.unit = unit
        self.style = style
        self.locale = locale
        self.precision = precision
    }

    /// Returns a copy of this style using the specified locale.
    ///
    /// - Parameter locale: The locale used to localize the unit and format the numeric value.
    /// - Returns: A format style with the specified locale.
    /// - Since: 1.0.0
    public func locale(_ locale: Locale) -> Self {
        .init(unit, style: style, locale: locale, precision: precision)
    }

    /// Returns a copy of this style using the specified precision.
    ///
    /// - Parameter precision: The precision used to format the numeric value.
    /// - Returns: A format style with the specified precision.
    /// - Since: 1.0.0
    public func precision(_ precision: NumberFormatStyleConfiguration.Precision) -> Self {
        .init(unit, style: style, locale: locale, precision: precision)
    }
}

/// Makes decimal unit format styles encodable and decodable.
///
/// - Since: 1.0.0
extension DecimalUnitFormatStyle: Codable {}
/// Makes decimal unit format styles usable in hashed collections.
///
/// - Since: 1.0.0
extension DecimalUnitFormatStyle: Hashable {}
/// Makes decimal unit format styles comparable.
///
/// - Since: 1.0.0
extension DecimalUnitFormatStyle: Equatable {}

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
        Localization.standard.withLocale(locale) {
            localizedQuantityString(
                value.localization(for: unit, style: style),
                quantity: value.value,
                locale: locale,
                precision: precision)
        }
    }
}
