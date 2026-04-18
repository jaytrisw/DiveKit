import Foundation
import DiveKitCore

public extension LocalizedTitleProviding where Self: LocalizationProviding, Component: TitleLocalizationComponent {
    /// The localized title resolved through the receiver's title component.
    ///
    /// - Since: 1.0.0
    var localizedTitle: String {
        localizedString(for: localization(for: .title), with: .init(describing: self))
    }
}
