import Foundation
import DiveKitCore

/// A display style used when localizing units and quantities.
///
/// - Since: 1.0.0
public enum LocalizationStyle: Sendable {
    /// A full unit name suitable for explanatory text.
    ///
    /// - Since: 1.0.0
    case full
    /// A short or abbreviated unit name.
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
