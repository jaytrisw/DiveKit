import os

/// Stores the localization configuration used by DiveKit.
///
/// Use ``standard`` to install a custom ``LocalizationResolver`` for all
/// DiveKit localization and formatting APIs.
///
/// - Since: 1.0.0
public final class Localization: Sendable {
    /// The shared localization configuration.
    ///
    /// - Since: 1.0.0
    public static let standard: Localization = .init()

    @TaskLocal private static var scopedResolver: LocalizationResolver?

    private let lock: OSAllocatedUnfairLock<LocalizationResolver> = .init(initialState: .default)

    /// The resolver used for DiveKit localization.
    ///
    /// Setting this property changes the resolver used by future localization
    /// and formatting calls that do not have a scoped override.
    ///
    /// - Since: 1.0.0
    public var resolver: LocalizationResolver {
        get { lock.withLock { $0 } }
        set { lock.withLock { $0 = newValue } }
    }

    var activeResolver: LocalizationResolver {
        Self.scopedResolver ?? resolver
    }

    /// Performs an operation with a temporary localization resolver.
    ///
    /// The resolver is scoped to the current task hierarchy and does not mutate
    /// ``resolver``.
    ///
    /// - Parameters:
    ///   - resolver: The resolver to use while `operation` runs.
    ///   - operation: The operation to perform.
    /// - Returns: The value returned by `operation`.
    /// - Since: 1.0.0
    public func withResolver<Result>(
        _ resolver: LocalizationResolver,
        operation: () throws -> Result) rethrows -> Result {
            try Self.$scopedResolver.withValue(resolver) {
                try operation()
            }
        }

    /// Performs an asynchronous operation with a temporary localization resolver.
    ///
    /// The resolver is scoped to the current task hierarchy and does not mutate
    /// ``resolver``.
    ///
    /// - Parameters:
    ///   - resolver: The resolver to use while `operation` runs.
    ///   - operation: The operation to perform.
    /// - Returns: The value returned by `operation`.
    /// - Since: 1.0.0
    public func withResolver<Result>(
        _ resolver: LocalizationResolver,
        operation: () async throws -> Result) async rethrows -> Result {
            try await Self.$scopedResolver.withValue(resolver) {
                try await operation()
            }
        }
}
