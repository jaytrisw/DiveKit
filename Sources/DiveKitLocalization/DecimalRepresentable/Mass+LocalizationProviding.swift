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
        localizationKeys.localization(for: component)
    }
}

private extension Mass.Unit {
    /// The localization keys for this unit.
    ///
    /// - Since: 1.0.0
    var localizationKeys: UnitLocalizationKeys {
        switch self {
            case .pounds:
                .init(
                    title: LocalizedKey.Unit.Mass.title,
                    shortDescription: LocalizedKey.Unit.Mass.shortDescriptionImperial,
                    fullDescription: LocalizedKey.Unit.Mass.fullDescriptionImperial,
                    shortQuantity: LocalizedKey.Unit.Mass.shortQuantityImperial,
                    fullQuantity: LocalizedKey.Unit.Mass.fullQuantityImperial)
            case .kilograms:
                .init(
                    title: LocalizedKey.Unit.Mass.title,
                    shortDescription: LocalizedKey.Unit.Mass.shortDescriptionMetric,
                    fullDescription: LocalizedKey.Unit.Mass.fullDescriptionMetric,
                    shortQuantity: LocalizedKey.Unit.Mass.shortQuantityMetric,
                    fullQuantity: LocalizedKey.Unit.Mass.fullQuantityMetric)
        }
    }
}
