import Foundation

extension Volume.Unit: LocalizationProviding {
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
