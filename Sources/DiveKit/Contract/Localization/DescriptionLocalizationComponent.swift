import Foundation

public protocol DescriptionLocalizationComponent {
    static func description(_ style: LocalizationStyle) -> Self
}
