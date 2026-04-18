import Foundation
import DiveKitCore

/// A component type that can request localized titles.
///
/// - Since: 1.0.0
public protocol TitleLocalizationComponent {
    /// The component value for a localized title.
    ///
    /// - Since: 1.0.0
    static var title: Self { get }
}
