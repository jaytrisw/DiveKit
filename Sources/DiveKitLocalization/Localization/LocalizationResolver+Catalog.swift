import Foundation

public extension LocalizationResolver {
    /// The default DiveKit localization resolver.
    ///
    /// This resolver reads DiveKit's packaged localization resources using the
    /// active locale.
    ///
    /// - Since: 1.0.0
    static let `default`: Self = .catalog(in: .module)

    /// Creates a resolver that reads a strings catalog from a bundle.
    ///
    /// The resolver uses the locale passed to ``LocalizationResolver/resolve``
    /// for string-catalog lookup and format-argument application.
    ///
    /// - Parameters:
    ///   - table: The strings catalog table name. Defaults to `Localizable`.
    ///   - bundle: The bundle that contains the strings catalog.
    /// - Returns: A resolver backed by the specified catalog.
    /// - Since: 1.0.0
    static func catalog(
        named table: String = "Localizable",
        in bundle: Bundle) -> Self {
        return .init { key, arguments, locale in
            String(localized: key, table: table, bundle: bundle, locale: locale)
                .applying(arguments, locale: locale)
        }
    }
}

private extension String {
    func applying(_ arguments: [CVarArg], locale: Locale) -> String {
        guard !arguments.isEmpty else {
            return self
        }

        return .init(format: self, locale: locale, arguments: arguments)
    }
}
