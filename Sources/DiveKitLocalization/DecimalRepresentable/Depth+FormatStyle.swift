import Foundation
import DiveKitCore

public extension FormatStyle where Self == DecimalUnitFormatStyle<Depth> {
    /// Creates a format style for depth values.
    ///
    /// - Parameters:
    ///   - unit: The depth unit to use.
    ///   - style: The localization style to use.
    ///   - locale: The locale used to localize the unit and format the numeric value.
    ///   - precision: The precision used to format the numeric value.
    /// - Returns: A depth format style.
    /// - Since: 1.0.0
    static func depth(
        _ unit: Depth.Unit,
        style: LocalizationStyle,
        locale: Locale = .autoupdatingCurrent,
        precision: NumberFormatStyleConfiguration.Precision? = nil) -> Self {
        .init(unit, style: style, locale: locale, precision: precision)
    }
}
