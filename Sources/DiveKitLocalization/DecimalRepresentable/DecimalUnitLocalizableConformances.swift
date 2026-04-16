import Foundation
import DiveKitCore

/// Makes depth values formattable with localized units.
///
/// - Since: 1.0.0
extension Depth: DecimalUnitLocalizable {}
/// Makes mass values formattable with localized units.
///
/// - Since: 1.0.0
extension Mass: DecimalUnitLocalizable {}
/// Makes pressure values formattable with localized units.
///
/// - Since: 1.0.0
extension Pressure: DecimalUnitLocalizable {}
/// Makes volume values formattable with localized units.
///
/// - Since: 1.0.0
extension Volume: DecimalUnitLocalizable {}

/// Makes rate values formattable with localized units.
///
/// - Since: 1.0.0
extension Rate: DecimalUnitLocalizable
    where
    Value: DecimalUnitLocalizable,
    Value.Unit.Component == LocalizationComponent {

    /// Returns a localized quantity string for the rate.
    ///
    /// - Parameters:
    ///   - unit: The rate unit to use.
    ///   - style: The localization style to use.
    /// - Returns: A localized string that combines the rate value and unit.
    /// - Since: 1.0.0
    public func localization(for unit: Unit, style: LocalizationStyle) -> String {
        unit.localization(for: .quantity(value, style))
    }
}
