import Foundation

extension Depth.Unit: LocalizationProviding {
    public func localization(for component: LocalizationComponent) -> String {
        switch component {
            case .title:
                localizedString(for: LocalizedKey.Unit.Depth.title.stringValue, with: .init(describing: self))
            case let .description(style):
                localizedString(for: description(style), with: .init(describing: self))
            case let .quantity(value, style):
                localizedString(for: quantity(style), quantity: value, with: .init(describing: self))
        }
    }
}

private extension Depth.Unit {
    func description(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.feet, .short):
                    LocalizedKey.Unit.Depth.shortDescriptionImperial
                case (.feet, .full):
                    LocalizedKey.Unit.Depth.fullDescriptionImperial
                case (.meters, .short):
                    LocalizedKey.Unit.Depth.shortDescriptionMetric
                case (.meters, .full):
                    LocalizedKey.Unit.Depth.fullDescriptionMetric
            }
        }
    }

    func quantity(_ style: LocalizationStyle) -> String {
        String {
            switch (self, style) {
                case (.feet, .short):
                    LocalizedKey.Unit.Depth.shortQuantityImperial
                case (.feet, .full):
                    LocalizedKey.Unit.Depth.fullQuantityImperial
                case (.meters, .short):
                    LocalizedKey.Unit.Depth.shortQuantityMetric
                case (.meters, .full):
                    LocalizedKey.Unit.Depth.fullQuantityMetric
            }
        }
    }
}
