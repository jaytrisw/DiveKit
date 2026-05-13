import Foundation
import DiveKitLocalization

/// Package-internal alias for localization keys used by test support.
///
/// - Since: 1.0.0
package typealias LocalizedKey = DiveKitLocalization.LocalizedKey

/// Resolves a localized string for a key in test support.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - comment: A translator-facing comment for the localized string.
/// - Returns: The localized string for `key`.
/// - Since: 1.0.0
package func localizedString(
    for key: String.LocalizationValue,
    with comment: @autoclosure () -> String) -> String {
        DiveKitLocalization.localizedString(for: key, with: comment())
    }

/// Resolves a localized quantity string for a key in test support.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - quantity: The numeric quantity used for pluralization or formatting.
///   - comment: A translator-facing comment for the localized string.
/// - Returns: The localized string for `key` and `quantity`.
/// - Since: 1.0.0
package func localizedString(
    for key: String.LocalizationValue,
    quantity: Double,
    with comment: @autoclosure () -> String) -> String {
        DiveKitLocalization.localizedString(for: key, quantity: quantity, with: comment())
    }
