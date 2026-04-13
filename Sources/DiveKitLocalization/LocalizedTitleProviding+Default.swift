import Foundation
import DiveKitCore

public extension LocalizedTitleProviding where Self: LocalizationProviding, Component: TitleLocalizationComponent {
    /// The localized title for this value.
    ///
    /// - Since: 1.0.0
    var localizedTitle: String {
        localizedString(for: localization(for: .title), with: .init(describing: self))
    }
}
