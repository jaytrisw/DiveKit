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
        localizedString(for: key, quantity: quantity, locale: .autoupdatingCurrent, precision: nil, with: comment())
    }

/// Looks up and formats a localized quantity string.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - quantity: The quantity used for plural selection.
///   - locale: The locale used to format the numeric value.
///   - precision: The precision used to format the numeric value.
///   - comment: A translator-facing comment for the key.
/// - Returns: The localized string with `quantity` applied.
/// - Since: 1.0.0
package func localizedString(
    for key: String,
    quantity: Double,
    locale: Locale,
    precision: NumberFormatStyleConfiguration.Precision?,
    with comment: @autoclosure () -> String) -> String {
        let localizedQuantity = localizedString(for: key, with: comment()).withQuantity(quantity)

        return localizedQuantityString(
            localizedQuantity,
            quantity: quantity,
            locale: locale,
            precision: precision,
            replacing: quantity.formattedForStringCatalog())
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

/// Replaces the default formatted number in a localized quantity string.
///
/// - Parameters:
///   - localizedQuantity: The localized quantity string.
///   - quantity: The numeric quantity to format.
///   - locale: The locale used to format the numeric value.
///   - precision: The precision used to format the numeric value.
/// - Returns: The localized quantity string with the requested numeric formatting.
/// - Since: 1.0.0
package func localizedQuantityString(
    _ localizedQuantity: String,
    quantity: Double,
    locale: Locale,
    precision: NumberFormatStyleConfiguration.Precision?) -> String {
        localizedQuantityString(
            localizedQuantity,
            quantity: quantity,
            locale: locale,
            precision: precision,
            replacing: quantity.localizedQuantityNumber())
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

private extension Double {
    /// Formats this value using DiveKit's default quantity precision.
    ///
    /// - Returns: A locale-aware number string.
    /// - Since: 1.0.0
    func localizedQuantityNumber() -> String {
        localizedQuantityNumber(locale: .autoupdatingCurrent, precision: nil)
    }

    /// Formats this value for insertion into a localized quantity string.
    ///
    /// - Parameters:
    ///   - locale: The locale used to format the numeric value.
    ///   - precision: The precision used to format the numeric value.
    /// - Returns: A locale-aware number string.
    /// - Since: 1.0.0
    func localizedQuantityNumber(
        locale: Locale,
        precision: NumberFormatStyleConfiguration.Precision?) -> String {
        formatted(.number.locale(locale).precision(precision ?? .fractionLength(0...3)))
    }

    /// Formats this value the way the string catalog quantity entries do today.
    ///
    /// - Returns: The catalog-formatted number string.
    /// - Since: 1.0.0
    func formattedForStringCatalog() -> String {
        String.localizedStringWithFormat("%.3f", self)
    }
}

private func localizedQuantityString(
    _ localizedQuantity: String,
    quantity: Double,
    locale: Locale,
    precision: NumberFormatStyleConfiguration.Precision?,
    replacing number: String) -> String {
        localizedQuantity.replacingFirstOccurrence(
            of: number,
            with: quantity.localizedQuantityNumber(locale: locale, precision: precision))
    }

private extension String {
    /// Replaces the first occurrence of a substring.
    ///
    /// - Parameters:
    ///   - target: The substring to replace.
    ///   - replacement: The replacement text.
    /// - Returns: A string with the first occurrence replaced.
    /// - Since: 1.0.0
    func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        guard let range = range(of: target) else {
            return self
        }

        return replacingCharacters(in: range, with: replacement)
    }
}
