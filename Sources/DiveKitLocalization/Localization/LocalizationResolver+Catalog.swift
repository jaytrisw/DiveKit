import Foundation

public extension LocalizationResolver {
    /// The default DiveKit localization resolver.
    ///
    /// This resolver reads DiveKit's packaged localization resources.
    ///
    /// - Since: 1.0.0
    static let `default`: Self = .catalog(in: .module)

    /// Creates a resolver that reads a strings catalog from a bundle.
    ///
    /// - Parameters:
    ///   - table: The strings catalog table name. Defaults to `Localizable`.
    ///   - bundle: The bundle that contains the strings catalog.
    /// - Returns: A resolver backed by the specified catalog.
    /// - Since: 1.0.0
    static func catalog(named table: String = "Localizable", in bundle: Bundle) -> Self {
        return .init { key, arguments in
            String(localized: key, table: table, bundle: bundle)
                .applying(arguments)
        }
    }
}

private extension String {
    func applying(_ arguments: [CVarArg]) -> String {
        guard !arguments.isEmpty else {
            return self
        }

        return .init(format: self, locale: Locale.current, arguments: arguments)
    }
}
