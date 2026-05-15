import Foundation
import DiveKitLocalization

/// Package-internal alias for localization keys used by test support.
///
/// - Since: 1.0.0
package typealias LocalizedKey = DiveKitLocalization.LocalizedKey

/// Resolves a localized string for a key in test support.
///
/// - Parameter key: The localization key to resolve.
/// - Returns: The localized string for `key`.
/// - Since: 1.0.0
package func localizedString(for key: String.LocalizationValue) -> String {
    DiveKitLocalization.localizedString(for: key)
}

/// Resolves a localized quantity string for a key in test support.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - quantity: The numeric quantity used for pluralization or formatting.
/// - Returns: The localized string for `key` and `quantity`.
/// - Since: 1.0.0
package func localizedString(
    for key: String.LocalizationValue,
    quantity: Double) -> String {
    DiveKitLocalization.localizedString(for: key, quantity: quantity)
}
