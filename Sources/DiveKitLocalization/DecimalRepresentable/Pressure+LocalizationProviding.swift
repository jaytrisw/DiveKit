import Foundation
import DiveKitCore

/// Allows pressure units to provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension Pressure.Unit: LocalizationProviding {
    /// Returns localized text for a pressure unit component.
    ///
    /// - Parameter component: The pressure unit component to localize.
    /// - Returns: The localized text for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        localizationKeys.localization(for: component)
    }
}

private extension Pressure.Unit {
    /// The localization keys for this unit.
    ///
    /// - Since: 1.0.0
    var localizationKeys: UnitLocalizationKeys {
        switch self {
            case .psi:
                .init(
                    title: LocalizedKey.Unit.Pressure.title,
                    shortDescription: LocalizedKey.Unit.Pressure.shortDescriptionImperial,
                    fullDescription: LocalizedKey.Unit.Pressure.fullDescriptionImperial,
                    shortQuantity: LocalizedKey.Unit.Pressure.shortQuantityImperial,
                    fullQuantity: LocalizedKey.Unit.Pressure.fullQuantityImperial)
            case .bar:
                .init(
                    title: LocalizedKey.Unit.Pressure.title,
                    shortDescription: LocalizedKey.Unit.Pressure.shortDescriptionMetric,
                    fullDescription: LocalizedKey.Unit.Pressure.fullDescriptionMetric,
                    shortQuantity: LocalizedKey.Unit.Pressure.shortQuantityMetric,
                    fullQuantity: LocalizedKey.Unit.Pressure.fullQuantityMetric)
            case .atmospheres:
                .init(
                    title: LocalizedKey.Unit.Pressure.title,
                    shortDescription: LocalizedKey.Unit.Pressure.shortDescriptionAtmospheres,
                    fullDescription: LocalizedKey.Unit.Pressure.fullDescriptionAtmospheres,
                    shortQuantity: LocalizedKey.Unit.Pressure.shortQuantityAtmospheres,
                    fullQuantity: LocalizedKey.Unit.Pressure.fullQuantityAtmospheres)
        }
    }
}
