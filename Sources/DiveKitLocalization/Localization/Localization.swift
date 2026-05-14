import os
import Foundation

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

    @TaskLocal private static var scopedState: ScopedState?

    private let state: OSAllocatedUnfairLock<State> = .init(
        initialState: .init(resolver: .default, locale: .autoupdatingCurrent))

    /// The resolver currently active for DiveKit localization.
    ///
    /// When called inside `withResolver(_:operation:)`, this returns the scoped
    /// resolver for the current task hierarchy. Outside a scoped override, it
    /// returns the shared default resolver.
    ///
    /// Use ``set(_:)`` to replace the shared default resolver.
    ///
    /// - Since: 1.0.0
    public var resolver: LocalizationResolver {
        Self.scopedState?.resolver ?? state.withLock { $0.resolver }
    }

    /// The locale currently active for DiveKit localization.
    ///
    /// When called inside `withLocale(_:operation:)`, this returns the scoped
    /// locale for the current task hierarchy. Outside a scoped override, it
    /// returns the shared default locale.
    ///
    /// Use `set(_:)` to replace the shared default locale.
    ///
    /// - Since: 1.0.0
    public var locale: Locale {
        Self.scopedState?.locale ?? state.withLock { $0.locale }
    }

    /// Replaces the shared default resolver used for DiveKit localization.
    ///
    /// This changes future localization and formatting calls that do not have a
    /// scoped resolver override. Scoped overrides installed with
    /// `withResolver(_:operation:)` continue to take precedence within
    /// their task hierarchy.
    ///
    /// - Parameter resolver: The resolver to use as the shared default.
    /// - Since: 1.0.0
    public func set(_ resolver: LocalizationResolver) {
        state.withLock { $0.resolver = resolver }
    }

    /// Replaces the shared default locale used for DiveKit localization.
    ///
    /// This changes future localization and formatting calls that do not have a
    /// scoped locale override. Scoped overrides installed with
    /// `withLocale(_:operation:)` continue to take precedence within their task
    /// hierarchy.
    ///
    /// - Parameter locale: The locale to use as the shared default.
    /// - Since: 1.0.0
    public func set(_ locale: Locale) {
        state.withLock { $0.locale = locale }
    }

    /// Replaces the shared default resolver with a locale-aware closure.
    ///
    /// This convenience wraps `resolve` in a ``LocalizationResolver`` and
    /// installs it as the shared default resolver.
    ///
    /// - Parameter resolve: The closure used to resolve localization keys.
    /// - Since: 1.0.0
    public func set(_ resolve: @escaping LocalizationResolver.Resolve) {
        set(.init(resolve: resolve))
    }

    /// Performs an operation with a temporary localization resolver.
    ///
    /// The resolver is scoped to the current task hierarchy and does not
    /// replace the shared default resolver.
    ///
    /// - Parameters:
    ///   - resolver: The resolver to use while `operation` runs.
    ///   - operation: The operation to perform.
    /// - Returns: The value returned by `operation`.
    /// - Since: 1.0.0
    public func withResolver<Result>(
        _ resolver: LocalizationResolver,
        operation: () throws -> Result) rethrows -> Result {
        try Self.$scopedState.withValue(Self.scopedState.setting(resolver)) {
            try operation()
        }
    }

    /// Performs an asynchronous operation with a temporary localization resolver.
    ///
    /// The resolver is scoped to the current task hierarchy and does not
    /// replace the shared default resolver.
    ///
    /// - Parameters:
    ///   - resolver: The resolver to use while `operation` runs.
    ///   - operation: The operation to perform.
    /// - Returns: The value returned by `operation`.
    /// - Since: 1.0.0
    public func withResolver<Result>(
        _ resolver: LocalizationResolver,
        operation: () async throws -> Result) async rethrows -> Result {
        try await Self.$scopedState.withValue(Self.scopedState.setting(resolver)) {
            try await operation()
        }
    }

    /// Performs an operation with a temporary localization locale.
    ///
    /// The locale is scoped to the current task hierarchy and does not replace
    /// the shared default locale.
    ///
    /// - Parameters:
    ///   - locale: The locale to use while `operation` runs.
    ///   - operation: The operation to perform.
    /// - Returns: The value returned by `operation`.
    /// - Since: 1.0.0
    public func withLocale<Result>(
        _ locale: Locale,
        operation: () throws -> Result) rethrows -> Result {
        try Self.$scopedState.withValue(Self.scopedState.setting(locale)) {
            try operation()
        }
    }

    /// Performs an asynchronous operation with a temporary localization locale.
    ///
    /// The locale is scoped to the current task hierarchy and does not replace
    /// the shared default locale.
    ///
    /// - Parameters:
    ///   - locale: The locale to use while `operation` runs.
    ///   - operation: The operation to perform.
    /// - Returns: The value returned by `operation`.
    /// - Since: 1.0.0
    public func withLocale<Result>(
        _ locale: Locale,
        operation: () async throws -> Result) async rethrows -> Result {
        try await Self.$scopedState.withValue(Self.scopedState.setting(locale)) {
            try await operation()
        }
    }
}

private extension Localization {
    struct State: Sendable {
        var resolver: LocalizationResolver
        var locale: Locale
    }

    struct ScopedState: Sendable {
        var resolver: LocalizationResolver?
        var locale: Locale?
    }
}

private extension Localization.ScopedState? {
    func setting(_ resolver: LocalizationResolver) -> Localization.ScopedState {
        .init(resolver: resolver, locale: self?.locale)
    }

    func setting(_ locale: Locale) -> Localization.ScopedState {
        .init(resolver: self?.resolver, locale: locale)
    }
}
