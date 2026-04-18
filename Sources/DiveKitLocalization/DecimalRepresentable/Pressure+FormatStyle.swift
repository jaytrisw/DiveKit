import Foundation
import DiveKitCore

public extension FormatStyle where Self == DecimalUnitFormatStyle<Pressure> {
    /// Creates a format style for pressure values.
    ///
    /// - Parameters:
    ///   - unit: The pressure unit to use.
    ///   - style: The localization style to use.
    /// - Returns: A pressure format style.
    /// - Since: 1.0.0
    static func pressure(_ unit: Pressure.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
