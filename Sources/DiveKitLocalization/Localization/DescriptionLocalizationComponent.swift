import Foundation
import DiveKitCore

/// A component type that can request localized descriptions.
///
/// - Since: 1.0.0
public protocol DescriptionLocalizationComponent {
    /// Creates a component value for a localized description.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: A description component.
    /// - Since: 1.0.0
    static func description(_ style: LocalizationStyle) -> Self
}
