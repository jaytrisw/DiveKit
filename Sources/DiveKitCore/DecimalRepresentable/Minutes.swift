import Foundation

/// A duration expressed in minutes.
///
/// `Minutes` is used by gas consumption calculations to represent elapsed dive
/// time without losing domain meaning to a raw `Double`.
///
/// - Since: 1.0.0
public struct Minutes: Sendable, Equatable, Hashable {
    /// The raw minute value.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a duration in minutes.
    ///
    /// - Parameter value: The raw minute value.
    /// - Since: 1.0.0
    public init(_ value: Double) {
        self.value = value
    }
}
