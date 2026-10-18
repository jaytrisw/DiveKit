import Foundation
import DiveKitCore

/// Makes volume units provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension Volume.Unit: LocalizationProviding {
    /// Returns localized text for a volume unit component.
    ///
    /// - Parameter component: The volume unit component to localize.
    /// - Returns: The localized text for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        localizationKeys.localization(for: component)
    }
}

private extension Volume.Unit {
    /// The localization keys for this unit.
    ///
    /// - Since: 1.0.0
    var localizationKeys: UnitLocalizationKeys {
        switch self {
            case .cubicFeet:
                .init(
                    title: LocalizedKey.Unit.Volume.title,
                    shortDescription: LocalizedKey.Unit.Volume.shortDescriptionImperial,
                    fullDescription: LocalizedKey.Unit.Volume.fullDescriptionImperial,
                    shortQuantity: LocalizedKey.Unit.Volume.shortQuantityImperial,
                    fullQuantity: LocalizedKey.Unit.Volume.fullQuantityImperial)
            case .liters:
                .init(
                    title: LocalizedKey.Unit.Volume.title,
                    shortDescription: LocalizedKey.Unit.Volume.shortDescriptionMetric,
                    fullDescription: LocalizedKey.Unit.Volume.fullDescriptionMetric,
                    shortQuantity: LocalizedKey.Unit.Volume.shortQuantityMetric,
                    fullQuantity: LocalizedKey.Unit.Volume.fullQuantityMetric)
        }
    }
}
