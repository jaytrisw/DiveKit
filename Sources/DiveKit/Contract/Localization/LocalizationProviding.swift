import Foundation
import SwiftUI

public protocol LocalizationProviding: LocalizedTitleProviding, LocalizedDescriptionProviding {
    associatedtype Component
    func localization(for component: Component) -> String
}
