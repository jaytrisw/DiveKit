import Foundation
import DiveKitCore

extension RateUnit: LocalizedTitleProviding, LocalizedDescriptionProviding, LocalizationProviding
    where
    BaseUnit: LocalizationProviding,
    BaseUnit.Component == LocalizationComponent {

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

    var baseUnit: BaseUnit {
        switch self {
            case let .perMinute(baseUnit): baseUnit
        }
    }

    func description(_ style: LocalizationStyle) -> LocalizedStringResource {
        switch style {
            case .short: LocalizedKey.Unit.Rate.shortDescription
            case .full: LocalizedKey.Unit.Rate.fullDescription
        }
    }

    func quantity(_ style: LocalizationStyle) -> LocalizedStringResource {
        switch style {
            case .short: LocalizedKey.Unit.Rate.shortQuantity
            case .full: LocalizedKey.Unit.Rate.fullQuantity
        }
    }
}
