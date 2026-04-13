import Foundation
import DiveKitCore

/// Allows pressure units to provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension Pressure.Unit: LocalizationProviding {
    /// Returns a localization key or localized quantity for a pressure unit component.
    ///
    /// - Parameter component: The pressure unit component to localize.
    /// - Returns: A localized string for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        switch component {
            case .title:
                localizedString(for: LocalizedKey.Unit.Pressure.title.stringValue, with: .init(describing: self))
            case let .description(style):
                localizedString(for: description(style), with: .init(describing: self))
            case let .quantity(value, style):
                localizedString(for: quantity(style), quantity: value, with: .init(describing: self))
        }
    }
}

private extension Pressure.Unit {
    /// Returns the localization key for a pressure unit description.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func description(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.psi, .short):
                    LocalizedKey.Unit.Pressure.shortDescriptionImperial
                case (.psi, .full):
                    LocalizedKey.Unit.Pressure.fullDescriptionImperial
                case (.bar, .short):
                    LocalizedKey.Unit.Pressure.shortDescriptionMetric
                case (.bar, .full):
                    LocalizedKey.Unit.Pressure.fullDescriptionMetric
                case (.atmospheres, .short):
                    LocalizedKey.Unit.Pressure.shortDescriptionAtmospheres
                case (.atmospheres, .full):
                    LocalizedKey.Unit.Pressure.fullDescriptionAtmospheres
            }
        }
    }

    /// Returns the localization key for a pressure unit quantity.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func quantity(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.psi, .short):
                    LocalizedKey.Unit.Pressure.shortQuantityImperial
                case (.psi, .full):
                    LocalizedKey.Unit.Pressure.fullQuantityImperial
                case (.bar, .short):
                    LocalizedKey.Unit.Pressure.shortQuantityMetric
                case (.bar, .full):
                    LocalizedKey.Unit.Pressure.fullQuantityMetric
                case (.atmospheres, .short):
                    LocalizedKey.Unit.Pressure.shortQuantityAtmospheres
                case (.atmospheres, .full):
                    LocalizedKey.Unit.Pressure.fullQuantityAtmospheres
            }
        }
    }
}
