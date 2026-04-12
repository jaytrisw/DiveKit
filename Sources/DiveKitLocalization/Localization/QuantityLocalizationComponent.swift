import Foundation
import DiveKitCore

public protocol QuantityLocalizationComponent {
    static func quantity(_ quantity: Double, _ style: LocalizationStyle) -> Self
}
