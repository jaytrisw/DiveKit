import Foundation

extension Error: LocalizedError {
    public var errorDescription: String? {
        localizedString(for: localizationKey, with: .init(describing: self))
    }
}
