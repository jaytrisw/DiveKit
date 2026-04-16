import Foundation
import DiveKitCore

public extension LocalizedDescriptionProviding where Self: LocalizationProviding, Component: DescriptionLocalizationComponent {
    /// Returns the localized description resolved through the receiver's description component.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: The localized description for `style`.
    /// - Since: 1.0.0
    func localizedDescription(for style: LocalizationStyle) -> String {
        localizedString(for: localization(for: .description(style)), with: .init(describing: self))
    }
}
