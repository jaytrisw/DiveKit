import Foundation

/// The localization keys of one unit: its quantity's title, and a description
/// and quantity key for each ``LocalizationStyle``.
///
/// Depth, mass, pressure and volume units each map themselves to one of these
/// and resolve every ``LocalizationComponent`` through it.
///
/// - Since: 1.0.0
package struct UnitLocalizationKeys {
    let title: String.LocalizationValue
    let shortDescription: String.LocalizationValue
    let fullDescription: String.LocalizationValue
    let shortQuantity: String.LocalizationValue
    let fullQuantity: String.LocalizationValue

    /// Returns localized text for `component`, choosing the key for its style.
    ///
    /// - Parameter component: The unit component to localize.
    /// - Returns: The localized text for `component`.
    /// - Since: 1.0.0
    func localization(for component: LocalizationComponent) -> String {
        switch component {
            case .title:
                localizedString(for: title)
            case let .description(style):
                localizedString(for: style == .short ? shortDescription : fullDescription)
            case let .quantity(value, style):
                localizedString(for: style == .short ? shortQuantity : fullQuantity, quantity: value)
        }
    }
}
