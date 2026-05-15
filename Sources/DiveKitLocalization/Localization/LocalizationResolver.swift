import Foundation

/// A value that resolves DiveKit localization keys.
///
/// A resolver receives the key as a `String.LocalizationValue` so catalog-backed
/// implementations can preserve Foundation localization metadata. The
/// `arguments` array contains C format arguments used by quantity and rate
/// strings. The `locale` controls catalog lookup and argument formatting for
/// resolvers that support locale-specific output.
///
/// - Since: 1.0.0
public struct LocalizationResolver: Sendable {
    /// Resolves a localization key, optional format arguments, and locale.
    ///
    /// - Since: 1.0.0
    public let resolve: Resolve

    /// Creates a locale-aware localization resolver.
    ///
    /// - Parameter resolve: The closure used to resolve localization keys.
    /// - Since: 1.0.0
    public init(resolve: @escaping Resolve) {
        self.resolve = resolve
    }

    /// A closure that resolves a localization key, optional format arguments,
    /// and locale.
    ///
    /// - Since: 1.0.0
    public typealias Resolve = @Sendable (String.LocalizationValue, [CVarArg], Locale) -> String
}
