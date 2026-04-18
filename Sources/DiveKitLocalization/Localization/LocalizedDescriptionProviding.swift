import Foundation
import DiveKitCore

/// A type that can provide localized descriptions.
///
/// - Since: 1.0.0
public protocol LocalizedDescriptionProviding {
    /// The style type accepted by the receiver.
    ///
    /// - Since: 1.0.0
    associatedtype Style

    /// Returns a localized description for a style.
    ///
    /// - Parameter style: The localization style to use.
    /// - Returns: The localized description for `style`.
    /// - Since: 1.0.0
    func localizedDescription(for style: Style) -> String
}
