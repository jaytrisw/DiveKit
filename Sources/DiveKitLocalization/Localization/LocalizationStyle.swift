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

/// Makes localization styles encodable and decodable.
///
/// - Since: 1.0.0
extension LocalizationStyle: Codable {}
/// Makes localization styles usable in hashed collections.
///
/// - Since: 1.0.0
extension LocalizationStyle: Hashable {}
/// Makes localization styles comparable.
///
/// - Since: 1.0.0
extension LocalizationStyle: Equatable {}
