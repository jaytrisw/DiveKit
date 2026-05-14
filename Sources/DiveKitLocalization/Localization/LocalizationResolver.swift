import Foundation

/// A value that resolves DiveKit localization keys.
///
/// A resolver receives the key as a `String.LocalizationValue` so catalog-backed
/// implementations can preserve Foundation localization metadata. The
/// `arguments` array contains C format arguments used by quantity and rate
/// strings.
///
/// - Since: 1.0.0
public struct LocalizationResolver: Sendable {
    /// Resolves a localization key and optional format arguments.
    ///
    /// - Since: 1.0.0
    public let resolve: Resolve

    /// Creates a localization resolver.
    ///
    /// - Parameter resolve: The closure used to resolve localization keys.
    /// - Since: 1.0.0
    public init(resolve: @escaping Resolve) {
        self.resolve = resolve
    }

    /// A closure that resolves a localization key and optional format arguments.
    ///
    /// - Since: 1.0.0
    public typealias Resolve = @Sendable (String.LocalizationValue, [CVarArg]) -> String
}

public extension LocalizationResolver {
    /// Resolves a localization key without format arguments.
    ///
    /// - Parameter key: The localization key to resolve.
    /// - Returns: The resolved localized string.
    /// - Since: 1.0.0
    func resolve(_ key: String.LocalizationValue) -> String {
        resolve(key, [])
    }
}
