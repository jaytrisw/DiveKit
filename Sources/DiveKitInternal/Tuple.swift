import Foundation

/// A lightweight package-internal pair of values.
///
/// ``Tuple`` gives internal calculation pipelines a named return type when two
/// intermediate values need to travel together. It is intentionally small and
/// does not add behavior beyond storing `first` and `second`.
///
/// ```swift
/// let pair = Tuple(first: Pressure(4), second: Rate<Pressure>(12))
/// let pressure = pair.first
/// let rate = pair.second
/// ```
///
/// - Note: Prefer a domain type when the pair has business meaning outside a
///   short internal pipeline.
/// - Since: 1.0.0
package struct Tuple<Value, Other> {
    /// The first value in the tuple.
    ///
    /// - Since: 1.0.0
    package let first: Value

    /// The second value in the tuple.
    ///
    /// - Since: 1.0.0
    package let second: Other

    /// Creates a new tuple with the provided values.
    ///
    /// - Parameters:
    ///   - first: The first value to store.
    ///   - second: The second value to store.
    /// - Since: 1.0.0
    package init(first: Value, second: Other) {
        self.first = first
        self.second = second
    }
}
