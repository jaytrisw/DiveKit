import Foundation
import DiveKitCore

extension Error: LocalizedError {
    public var errorDescription: String? {
        localizedString(for: localizationKey, with: .init(describing: self))
    }
}
