import SwiftUI

internal extension LocalizedStringKey {
    var stringValue: String {
        Mirror(reflecting: self)
            .children
            .first(where: { $0.label == "key" })
            .flatMap { $0.value as? String }
            .forceUnwrap("Failed to extract the key from \(self)")
    }
}

internal func localizedString(
    for key: String,
    from bundle: Bundle,
    with comment: @autoclosure () -> String) -> String {
        returning(with: key) {
            guard NSLocalizedString($0, bundle: Error.mainBundle, comment: comment()) != $0 else {
                return NSLocalizedString($0, bundle: .module, comment: comment())
            }
            return NSLocalizedString($0, bundle: Error.mainBundle, comment: comment())
        }
    }

internal func returning<T, R>(with input: T, closure: (T) -> R) -> R {
    closure(input)
}
