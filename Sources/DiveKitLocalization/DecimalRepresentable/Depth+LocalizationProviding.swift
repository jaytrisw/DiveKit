import Foundation
import DiveKitCore

/// Allows depth units to provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension Depth.Unit: LocalizationProviding {
    /// Returns a localization key or localized quantity for a depth unit component.
    ///
    /// - Parameter component: The depth unit component to localize.
    /// - Returns: A localized string for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        switch component {
            case .title:
                localizedString(for: LocalizedKey.Unit.Depth.title.stringValue, with: .init(describing: self))
            case let .description(style):
                localizedString(for: description(style), with: .init(describing: self))
            case let .quantity(value, style):
                localizedString(for: quantity(style), quantity: value, with: .init(describing: self))
        }
    }
}

private extension Depth.Unit {
    /// Returns the localization key for a depth unit description.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func description(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.feet, .short):
                    LocalizedKey.Unit.Depth.shortDescriptionImperial
                case (.feet, .full):
                    LocalizedKey.Unit.Depth.fullDescriptionImperial
                case (.meters, .short):
                    LocalizedKey.Unit.Depth.shortDescriptionMetric
                case (.meters, .full):
                    LocalizedKey.Unit.Depth.fullDescriptionMetric
            }
        }
    }

    /// Returns the localization key for a depth unit quantity.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func quantity(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.feet, .short):
                    LocalizedKey.Unit.Depth.shortQuantityImperial
                case (.feet, .full):
                    LocalizedKey.Unit.Depth.fullQuantityImperial
                case (.meters, .short):
                    LocalizedKey.Unit.Depth.shortQuantityMetric
                case (.meters, .full):
                    LocalizedKey.Unit.Depth.fullQuantityMetric
            }
        }
    }
}
