import Foundation
import DiveKitCore

public extension FormatStyle where Self == DecimalUnitFormatStyle<Depth> {
    /// Creates a format style for depth values.
    ///
    /// - Parameters:
    ///   - unit: The depth unit to use.
    ///   - style: The localization style to use.
    /// - Returns: A depth format style.
    /// - Since: 1.0.0
    static func depth(_ unit: Depth.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
