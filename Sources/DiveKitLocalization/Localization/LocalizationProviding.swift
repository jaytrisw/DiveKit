import Foundation
import DiveKitCore

/// A type that resolves localized text for supported components.
///
/// `LocalizationProviding` supplies the component lookup used by default title
/// and description localization helpers.
///
/// - Since: 1.0.0
public protocol LocalizationProviding: LocalizedTitleProviding, LocalizedDescriptionProviding {
    /// The component type accepted by the receiver.
    ///
    /// - Since: 1.0.0
    associatedtype Component

    /// Returns localized text for a component.
    ///
    /// - Parameter component: The component to localize.
    /// - Returns: The localized text for `component`.
    /// - Since: 1.0.0
    func localization(for component: Component) -> String
}
