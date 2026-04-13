import Foundation
import DiveKitCore

/// Allows rate units to provide localized titles, descriptions, and quantities.
///
/// - Since: 1.0.0
extension RateUnit: LocalizedTitleProviding, LocalizedDescriptionProviding, LocalizationProviding
    where
    BaseUnit: LocalizationProviding,
    BaseUnit.Component == LocalizationComponent {

    /// Returns a localization key or localized quantity for a rate unit component.
    ///
    /// - Parameter component: The rate unit component to localize.
    /// - Returns: A localized string for `component`.
    /// - Since: 1.0.0
    public func localization(for component: LocalizationComponent) -> String {
        switch component {
            case .title:
                localizedString(for: LocalizedKey.Unit.Rate.title.stringValue, with: .init(describing: self))
                    .withArguments(baseUnit.localizedTitle)
            case let .description(style):
                localizedString(for: description(style).stringValue, with: .init(describing: self))
                    .withArguments(baseUnit.localizedDescription(for: style))
            case let .quantity(value, style):
                localizedString(for: quantity(style).stringValue, with: .init(describing: self))
                    .withArguments(baseUnit.localization(for: .quantity(value, style)))
        }
    }
}

private extension RateUnit
    where
    BaseUnit: LocalizationProviding,
    BaseUnit.Component == LocalizationComponent {

    /// The base unit wrapped by this rate unit.
    ///
    /// - Since: 1.0.0
    var baseUnit: BaseUnit {
        switch self {
            case let .perMinute(baseUnit): baseUnit
        }
    }

    /// Returns the localization resource for a rate unit description.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localized string resource.
    /// - Since: 1.0.0
    func description(_ style: LocalizationStyle) -> LocalizedStringResource {
        switch style {
            case .short: LocalizedKey.Unit.Rate.shortDescription
            case .full: LocalizedKey.Unit.Rate.fullDescription
        }
    }

    /// Returns the localization resource for a rate unit quantity.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A localized string resource.
    /// - Since: 1.0.0
    func quantity(_ style: LocalizationStyle) -> LocalizedStringResource {
        switch style {
            case .short: LocalizedKey.Unit.Rate.shortQuantity
            case .full: LocalizedKey.Unit.Rate.fullQuantity
        }
    }
}
