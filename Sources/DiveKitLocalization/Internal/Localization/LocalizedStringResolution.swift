import Foundation

/// Looks up a localized string with the active resolver.
///
/// - Parameters:
///   - key: The localization key to resolve.
///   - comment: A translator-facing comment for the key.
/// - Returns: The localized string for `key`.
/// - Since: 1.0.0
package func localizedString(
    for key: String.LocalizationValue,
    with comment: @autoclosure () -> String) -> String {
        Localization.standard.activeResolver.resolve(key)
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
    for key: String.LocalizationValue,
    quantity: Double,
    with comment: @autoclosure () -> String) -> String {
        localizedString(for: key, quantity: quantity, locale: .autoupdatingCurrent, precision: .none, with: comment())
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
    for key: String.LocalizationValue,
    quantity: Double,
    locale: Locale,
    precision: NumberFormatStyleConfiguration.Precision?,
    with comment: @autoclosure () -> String) -> String {
        let localizedQuantity = Localization.standard.activeResolver.resolve(key, [quantity])

        return localizedQuantityString(
            localizedQuantity,
            quantity: quantity,
            locale: locale,
            precision: precision,
            replacing: quantity.formattedForStringCatalog())
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

package extension String {
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
        localizedQuantityNumber(locale: .autoupdatingCurrent, precision: .none)
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
