import Foundation

extension Mass.Unit: LocalizationProviding {
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
