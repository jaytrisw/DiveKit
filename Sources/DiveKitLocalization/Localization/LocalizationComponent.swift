import Foundation
import DiveKitCore

/// The kind of localized content requested from a unit or domain value.
///
/// - Since: 1.0.0
public enum LocalizationComponent: Sendable {
    /// The localized title for a value or unit.
    ///
    /// - Since: 1.0.0
    case title
    /// The localized description for a style.
    ///
    /// - Since: 1.0.0
    case description(_ style: LocalizationStyle)
    /// The localized quantity string for a value and style.
    ///
    /// - Since: 1.0.0
    case quantity(_ quantity: Double, _ style: LocalizationStyle)
}

/// Allows localization components to be encoded and decoded.
///
/// - Since: 1.0.0
extension LocalizationComponent: Codable {}
/// Allows localization components to be used in hashed collections.
///
/// - Since: 1.0.0
extension LocalizationComponent: Hashable {}
/// Allows localization components to be compared.
///
/// - Since: 1.0.0
extension LocalizationComponent: Equatable {}
/// Allows `LocalizationComponent.title` to satisfy title component requirements.
///
/// - Since: 1.0.0
extension LocalizationComponent: TitleLocalizationComponent {}
/// Allows `LocalizationComponent.description(_:)` to satisfy description component requirements.
///
/// - Since: 1.0.0
extension LocalizationComponent: DescriptionLocalizationComponent {}
/// Allows `LocalizationComponent.quantity(_:_:)` to satisfy quantity component requirements.
///
/// - Since: 1.0.0
extension LocalizationComponent: QuantityLocalizationComponent {}
