import Foundation
import DiveKitCore

/// The kind of localized content requested from a unit or domain value.
///
/// - Since: 1.0.0
public enum LocalizationComponent: Sendable {
    /// The localized title for a value or unit family.
    ///
    /// - Since: 1.0.0
    case title
    /// The localized unit description for a style.
    ///
    /// - Since: 1.0.0
    case description(_ style: LocalizationStyle)
    /// The localized quantity string for a value and style.
    ///
    /// - Since: 1.0.0
    case quantity(_ quantity: Double, _ style: LocalizationStyle)
}

/// Makes localization components encodable and decodable.
///
/// - Since: 1.0.0
extension LocalizationComponent: Codable {}
/// Makes localization components usable in hashed collections.
///
/// - Since: 1.0.0
extension LocalizationComponent: Hashable {}
/// Makes localization components comparable.
///
/// - Since: 1.0.0
extension LocalizationComponent: Equatable {}
/// Makes ``LocalizationComponent/title`` satisfy title component requirements.
///
/// - Since: 1.0.0
extension LocalizationComponent: TitleLocalizationComponent {}
/// Makes ``LocalizationComponent/description(_:)`` satisfy description component requirements.
///
/// - Since: 1.0.0
extension LocalizationComponent: DescriptionLocalizationComponent {}
/// Makes ``LocalizationComponent/quantity(_:_:)`` satisfy quantity component requirements.
///
/// - Since: 1.0.0
extension LocalizationComponent: QuantityLocalizationComponent {}
