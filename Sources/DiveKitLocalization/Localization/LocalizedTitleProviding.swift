import Foundation
import DiveKitCore

/// A type that can provide a localized title.
///
/// - Since: 1.0.0
public protocol LocalizedTitleProviding {
    /// The localized title.
    ///
    /// - Since: 1.0.0
    var localizedTitle: String { get }
}
