import Foundation

public extension LocalizedTitleProviding where Self: LocalizationProviding, Component: TitleLocalizationComponent {
    var localizedTitle: String {
        localizedString(for: localization(for: .title), with: .init(describing: self))
    }
}
