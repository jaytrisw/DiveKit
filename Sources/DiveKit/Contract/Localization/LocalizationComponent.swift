import Foundation

public enum LocalizationComponent {
    case title
    case description(_ style: LocalizationStyle)
    case quantity(_ quantity: Double, _ style: LocalizationStyle)
}

extension LocalizationComponent: Codable {}
extension LocalizationComponent: Hashable {}
extension LocalizationComponent: Equatable {}
extension LocalizationComponent: TitleLocalizationComponent {}
extension LocalizationComponent: DescriptionLocalizationComponent {}
extension LocalizationComponent: QuantityLocalizationComponent {}

public extension LocalizedTitleProviding where Self: LocalizationProviding, Self.Component: TitleLocalizationComponent {
    var localizedTitle: String {
        localizedString(for: localization(for: .title), with: .init(describing: self))
    }
}

public extension LocalizedDescriptionProviding where Self: LocalizationProviding, Self.Component: DescriptionLocalizationComponent {
    func localizedDescription(for style: LocalizationStyle) -> String {
        localizedString(for: localization(for: .description(style)), with: .init(describing: self))
    }
}
