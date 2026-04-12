import Foundation
import DiveKitCore

public protocol LocalizationProviding: LocalizedTitleProviding, LocalizedDescriptionProviding {
    associatedtype Component
    func localization(for component: Component) -> String
}
