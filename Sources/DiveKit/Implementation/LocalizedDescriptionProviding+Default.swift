import Foundation

public extension LocalizedDescriptionProviding where Self: LocalizationProviding, Component: DescriptionLocalizationComponent {
    func localizedDescription(for style: LocalizationStyle) -> String {
        localizedString(for: localization(for: .description(style)), with: .init(describing: self))
    }
}
