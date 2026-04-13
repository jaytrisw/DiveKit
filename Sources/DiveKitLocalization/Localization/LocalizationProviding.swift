import Foundation
import DiveKitCore

/// A type that resolves localization keys for supported components.
///
/// `LocalizationProviding` supplies the key lookup used by default title and
/// description localization helpers.
///
/// - Since: 1.0.0
public protocol LocalizationProviding: LocalizedTitleProviding, LocalizedDescriptionProviding {
    /// The component type accepted by the receiver.
    ///
    /// - Since: 1.0.0
    associatedtype Component

    /// Returns a localization key for a component.
    ///
    /// - Parameter component: The component to localize.
    /// - Returns: A localization key.
    /// - Since: 1.0.0
    func localization(for component: Component) -> String
}
