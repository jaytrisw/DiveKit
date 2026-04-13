import SwiftUI
import DiveKitCore

/// Internal helpers for converting localized string resources into raw keys.
///
/// - Since: 1.0.0
internal extension String {
    /// Creates a string from a localized string resource key.
    ///
    /// - Parameter key: A closure returning the localized string resource.
    /// - Since: 1.0.0
    init(_ key: () -> LocalizedStringResource) {
        self.init(key().stringValue)
    }
}
