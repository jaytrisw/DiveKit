import Foundation
import DiveKitCore

/// Allows depth units to provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension Depth.Unit: LocalizationProviding {
    /// Returns localized text for a depth unit component.
    ///
    /// - Parameter component: The depth unit component to localize.
    /// - Returns: The localized text for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        localizationKeys.localization(for: component)
    }
}

private extension Depth.Unit {
    /// The localization keys for this unit.
    ///
    /// - Since: 1.0.0
    var localizationKeys: UnitLocalizationKeys {
        switch self {
            case .feet:
                .init(
                    title: LocalizedKey.Unit.Depth.title,
                    shortDescription: LocalizedKey.Unit.Depth.shortDescriptionImperial,
                    fullDescription: LocalizedKey.Unit.Depth.fullDescriptionImperial,
                    shortQuantity: LocalizedKey.Unit.Depth.shortQuantityImperial,
                    fullQuantity: LocalizedKey.Unit.Depth.fullQuantityImperial)
            case .meters:
                .init(
                    title: LocalizedKey.Unit.Depth.title,
                    shortDescription: LocalizedKey.Unit.Depth.shortDescriptionMetric,
                    fullDescription: LocalizedKey.Unit.Depth.fullDescriptionMetric,
                    shortQuantity: LocalizedKey.Unit.Depth.shortQuantityMetric,
                    fullQuantity: LocalizedKey.Unit.Depth.fullQuantityMetric)
        }
    }
}
