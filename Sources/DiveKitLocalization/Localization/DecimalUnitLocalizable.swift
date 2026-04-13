import Foundation
import DiveKitCore

/// A decimal domain value whose unit can be localized.
///
/// Conforming values provide their raw number and unit localization behavior so
/// `DecimalUnitFormatStyle` can produce localized output.
///
/// - Since: 1.0.0
public protocol DecimalUnitLocalizable: Sendable {
    /// The unit type used to localize this value.
    ///
    /// - Since: 1.0.0
    associatedtype Unit: UnitRepresentable, LocalizationProviding, Codable, Hashable, Equatable

    /// The raw numeric value.
    ///
    /// - Since: 1.0.0
    var value: Double { get }

    /// Creates a decimal localizable value.
    ///
    /// - Parameter value: The raw numeric value.
    /// - Since: 1.0.0
    init(_ value: Double)

    /// Returns a localized string for the value in a unit and style.
    ///
    /// - Parameters:
    ///   - unit: The unit to use for localization.
    ///   - style: The localization style to use.
    /// - Returns: A localized string.
    /// - Since: 1.0.0
    func localization(for unit: Unit, style: LocalizationStyle) -> String
}

/// Provides default quantity localization for decimal localizable values.
///
/// - Since: 1.0.0
extension DecimalUnitLocalizable where Unit.Component: QuantityLocalizationComponent {
    /// Returns a localized quantity string using the unit's quantity component.
    ///
    /// - Parameters:
    ///   - unit: The unit to use for localization.
    ///   - style: The localization style to use.
    /// - Returns: A localized quantity string.
    /// - Since: 1.0.0
    public func localization(for unit: Unit, style: LocalizationStyle) -> String {
        unit.localization(for: .quantity(value, style))
    }
}
