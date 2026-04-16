import Foundation
import DiveKitCore

/// Makes mass units provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension Mass.Unit: LocalizationProviding {
    /// Returns localized text for a mass unit component.
    ///
    /// - Parameter component: The mass unit component to localize.
    /// - Returns: The localized text for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        switch component {
            case .title:
                localizedString(for: LocalizedKey.Unit.Mass.title.stringValue, with: .init(describing: self))
            case let .description(style):
                localizedString(for: description(style), with: .init(describing: self))
            case let .quantity(value, style):
                localizedString(for: quantity(style), quantity: value, with: .init(describing: self))
        }
    }
}

private extension Mass.Unit {
    /// Returns the localization key for a mass unit description.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func description(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.pounds, .short):
                    LocalizedKey.Unit.Mass.shortDescriptionImperial
                case (.pounds, .full):
                    LocalizedKey.Unit.Mass.fullDescriptionImperial
                case (.kilograms, .short):
                    LocalizedKey.Unit.Mass.shortDescriptionMetric
                case (.kilograms, .full):
                    LocalizedKey.Unit.Mass.fullDescriptionMetric
            }
        }
    }

    /// Returns the localization key for a mass unit quantity.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func quantity(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.pounds, .short):
                    LocalizedKey.Unit.Mass.shortQuantityImperial
                case (.pounds, .full):
                    LocalizedKey.Unit.Mass.fullQuantityImperial
                case (.kilograms, .short):
                    LocalizedKey.Unit.Mass.shortQuantityMetric
                case (.kilograms, .full):
                    LocalizedKey.Unit.Mass.fullQuantityMetric
            }
        }
    }
}
