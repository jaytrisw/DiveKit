import Foundation
import DiveKitCore

public extension FormatStyle where Self == DecimalUnitFormatStyle<Volume> {
    /// Creates a format style for volume values.
    ///
    /// - Parameters:
    ///   - unit: The volume unit to use.
    ///   - style: The localization style to use.
    /// - Returns: A volume format style.
    /// - Since: 1.0.0
    static func volume(_ unit: Volume.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
