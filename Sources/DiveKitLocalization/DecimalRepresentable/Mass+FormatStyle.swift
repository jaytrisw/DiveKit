import Foundation
import DiveKitCore

public extension FormatStyle where Self == DecimalUnitFormatStyle<Mass> {
    /// Creates a format style for mass values.
    ///
    /// - Parameters:
    ///   - unit: The mass unit to use.
    ///   - style: The localization style to use.
    /// - Returns: A mass format style.
    /// - Since: 1.0.0
    static func mass(_ unit: Mass.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
