import Foundation

public extension Error {
    var localizedDescription: String {
        localizedString(for: localizationKey, from: Error.mainBundle, with: .init(describing: self))
    }
}
