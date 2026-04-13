import Foundation
import DiveKitCore

/// Allows depth values to be formatted with localized units.
///
/// - Since: 1.0.0
extension Depth: DecimalUnitLocalizable {}
/// Allows mass values to be formatted with localized units.
///
/// - Since: 1.0.0
extension Mass: DecimalUnitLocalizable {}
/// Allows pressure values to be formatted with localized units.
///
/// - Since: 1.0.0
extension Pressure: DecimalUnitLocalizable {}
/// Allows volume values to be formatted with localized units.
///
/// - Since: 1.0.0
extension Volume: DecimalUnitLocalizable {}

/// Allows rate values to be formatted with localized units.
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
    /// - Returns: A localized rate quantity.
    /// - Since: 1.0.0
    public func localization(for unit: Unit, style: LocalizationStyle) -> String {
        unit.localization(for: .quantity(value, style))
    }
}
