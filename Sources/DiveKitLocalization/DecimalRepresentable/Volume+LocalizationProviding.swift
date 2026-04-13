import Foundation
import DiveKitCore

/// Allows volume units to provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension Volume.Unit: LocalizationProviding {
    /// Returns a localization key or localized quantity for a volume unit component.
    ///
    /// - Parameter component: The volume unit component to localize.
    /// - Returns: A localized string for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        switch component {
            case .title:
                localizedString(for: LocalizedKey.Unit.Volume.title.stringValue, with: .init(describing: self))
            case let .description(style):
                localizedString(for: description(style), with: .init(describing: self))
            case let .quantity(value, style):
                localizedString(for: quantity(style), quantity: value, with: .init(describing: self))
        }
    }
}

private extension Volume.Unit {
    /// Returns the localization key for a volume unit description.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func description(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.cubicFeet, .short):
                    LocalizedKey.Unit.Volume.shortDescriptionImperial
                case (.cubicFeet, .full):
                    LocalizedKey.Unit.Volume.fullDescriptionImperial
                case (.liters, .short):
                    LocalizedKey.Unit.Volume.shortDescriptionMetric
                case (.liters, .full):
                    LocalizedKey.Unit.Volume.fullDescriptionMetric
            }
        }
    }

    /// Returns the localization key for a volume unit quantity.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func quantity(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.cubicFeet, .short):
                    LocalizedKey.Unit.Volume.shortQuantityImperial
                case (.cubicFeet, .full):
                    LocalizedKey.Unit.Volume.fullQuantityImperial
                case (.liters, .short):
                    LocalizedKey.Unit.Volume.shortQuantityMetric
                case (.liters, .full):
                    LocalizedKey.Unit.Volume.fullQuantityMetric
            }
        }
    }
}
