import Foundation

extension Pressure.Unit: LocalizationProviding {
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
