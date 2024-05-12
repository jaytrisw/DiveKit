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
    with comment: @autoclosure () -> String) -> String {
        returning(with: key) {
            guard let localizedString = NSLocalizedString($0, bundle: LocalizedKey.mainBundle, comment: comment()) else {
                return NSLocalizedString($0, bundle: .module, comment: comment())
            }
            return localizedString
        }
    }

internal func localizedString(
    for key: String,
    quantity: Double,
    with comment: @autoclosure () -> String) -> String {
        localizedString(for: key, with: comment())
            .withQuantity(quantity)
    }

internal func returning<T, R>(with input: T, closure: (T) -> R) -> R {
    closure(input)
}

internal func NSLocalizedString(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle,
    comment: String) -> String? {
        guard NSLocalizedString(key, bundle: bundle, value: "", comment: comment) != key else {
            return nil
        }
        return NSLocalizedString(key, bundle: bundle, value: "", comment: comment)
}

internal extension String {
    func withQuantity(_ argument: Double) -> String {
        .localizedStringWithFormat(self, argument)
    }
}
