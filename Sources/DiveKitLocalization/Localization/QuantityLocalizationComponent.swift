import Foundation
import DiveKitCore

/// A component type that can request localized quantity strings.
///
/// - Since: 1.0.0
public protocol QuantityLocalizationComponent {
    /// Creates a component value for a localized quantity.
    ///
    /// - Parameters:
    ///   - quantity: The numeric quantity to localize.
    ///   - style: The localization style to use.
    /// - Returns: A quantity component.
    /// - Since: 1.0.0
    static func quantity(_ quantity: Double, _ style: LocalizationStyle) -> Self
}
