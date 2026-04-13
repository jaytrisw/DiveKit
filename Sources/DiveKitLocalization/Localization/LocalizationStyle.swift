import Foundation
import DiveKitCore

/// A style used when localizing units and descriptions.
///
/// - Since: 1.0.0
public enum LocalizationStyle: Sendable {
    /// A full, human-readable localization.
    ///
    /// - Since: 1.0.0
    case full
    /// A short or abbreviated localization.
    ///
    /// - Since: 1.0.0
    case short
}

/// Allows localization styles to be encoded and decoded.
///
/// - Since: 1.0.0
extension LocalizationStyle: Codable {}
/// Allows localization styles to be used in hashed collections.
///
/// - Since: 1.0.0
extension LocalizationStyle: Hashable {}
/// Allows localization styles to be compared.
///
/// - Since: 1.0.0
extension LocalizationStyle: Equatable {}
