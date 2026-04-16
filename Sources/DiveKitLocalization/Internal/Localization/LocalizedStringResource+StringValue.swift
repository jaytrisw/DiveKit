import SwiftUI
import DiveKitCore
import DiveKitInternal

package extension LocalizedStringResource {
    /// The raw key stored in a localized string resource.
    ///
    /// - Warning: This uses reflection to extract the key and will raise an
    ///   exception if SwiftUI changes the reflected storage shape.
    /// - Since: 1.0.0
    var stringValue: String {
        Mirror(reflecting: self)
            .children
            .first(where: { $0.label == "key" })
            .flatMap { $0.value as? String }
            .forceUnwrap("Failed to extract the key from \(self)")
    }
}

/// Looks up a localized string in the active bundle, falling back to the module bundle.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - comment: A translator-facing comment for the key.
/// - Returns: The localized string for `key`.
/// - Since: 1.0.0
package func localizedString(
    for key: String,
    with comment: @autoclosure () -> String) -> String {
        returning(with: key) {
            guard let localizedString = NSLocalizedString($0, bundle: LocalizedKey.mainBundle, comment: comment()) else {
                return NSLocalizedString($0, bundle: .module, comment: comment())
            }
            return localizedString
        }
    }

/// Looks up and formats a localized quantity string.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - quantity: The quantity used for localized string formatting.
///   - comment: A translator-facing comment for the key.
/// - Returns: The localized string with `quantity` applied.
/// - Since: 1.0.0
package func localizedString(
    for key: String,
    quantity: Double,
    with comment: @autoclosure () -> String) -> String {
        localizedString(for: key, with: comment()).withQuantity(quantity)
            .components(separatedBy: " ")
            .map {
                guard let number = Double($0) else {
                    return $0
                }
                return number.formatted(.number)
            }
            .joined(separator: " ")
    }

/// Invokes a closure with an input value and returns the closure result.
///
/// - Parameters:
///   - input: The input value.
///   - closure: The closure to execute with `input`.
/// - Returns: The closure result.
/// - Since: 1.0.0
package func returning<T, R>(with input: T, closure: (T) -> R) -> R {
    closure(input)
}

/// Returns a localized string from a specific bundle when the key exists.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - tableName: The table name. Currently unused.
///   - bundle: The bundle to search.
///   - comment: A translator-facing comment for the key.
/// - Returns: The localized string, or `nil` when the bundle has no value for `key`.
/// - Since: 1.0.0
package func NSLocalizedString(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle,
    comment: String) -> String? {
        guard NSLocalizedString(key, bundle: bundle, value: "", comment: comment) != key else {
            return nil
        }
        return NSLocalizedString(key, bundle: bundle, value: "", comment: comment)
}

package extension String {
    /// Formats this localized format string with a quantity.
    ///
    /// - Parameter argument: The quantity to insert.
    /// - Returns: A localized string with `argument` applied.
    /// - Since: 1.0.0
    func withQuantity(_ argument: Double) -> String {
        .localizedStringWithFormat(self, argument)
    }

    /// Formats this string with C varargs using the current locale.
    ///
    /// - Parameter arguments: The format arguments to apply.
    /// - Returns: A formatted string.
    /// - Since: 1.0.0
    func withArguments(_ arguments: CVarArg...) -> String {
        .init(format: self, locale: .current, arguments: arguments)
    }
}
