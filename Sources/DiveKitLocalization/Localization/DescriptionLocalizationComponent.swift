import Foundation
import DiveKitCore

public protocol DescriptionLocalizationComponent {
    static func description(_ style: LocalizationStyle) -> Self
}
