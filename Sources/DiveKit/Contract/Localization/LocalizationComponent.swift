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
