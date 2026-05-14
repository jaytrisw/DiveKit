import Foundation
import DiveKitCore

public extension FormatStyle where Self == DecimalUnitFormatStyle<Pressure> {
    /// Creates a format style for pressure values.
    ///
    /// - Parameters:
    ///   - unit: The pressure unit to use.
    ///   - style: The localization style to use.
    ///   - locale: The locale used to localize the unit and format the numeric value.
    ///   - precision: The precision used to format the numeric value.
    /// - Returns: A pressure format style.
    /// - Since: 1.0.0
    static func pressure(
        _ unit: Pressure.Unit,
        style: LocalizationStyle,
        locale: Locale = .autoupdatingCurrent,
        precision: NumberFormatStyleConfiguration.Precision? = nil) -> Self {
        .init(unit, style: style, locale: locale, precision: precision)
    }
}
