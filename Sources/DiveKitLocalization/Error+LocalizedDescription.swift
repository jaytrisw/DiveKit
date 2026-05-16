import Foundation
import DiveKitCore

/// Makes DiveKit domain errors provide localized descriptions.
///
/// - Since: 1.0.0
extension Error: LocalizedError {
    /// The localized error description.
    ///
    /// - Since: 1.0.0
    public var errorDescription: String? {
        localizedString(for: localizationValue)
    }
}
