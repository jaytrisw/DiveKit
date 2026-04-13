import Foundation
import DiveKitCore

/// Allows DiveKit domain errors to provide localized descriptions.
///
/// - Since: 1.0.0
extension Error: LocalizedError {
    /// The localized error description.
    ///
    /// - Since: 1.0.0
    public var errorDescription: String? {
        localizedString(for: localizationKey, with: .init(describing: self))
    }
}
