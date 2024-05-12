import Foundation

public extension Error {
    var localizedDescription: String {
        localizedString(for: localizationKey, with: .init(describing: self))
    }
}
