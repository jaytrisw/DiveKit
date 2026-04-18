import Foundation

/// Trace gases in a breathing mix.
///
/// `Trace` represents the small non-oxygen, non-nitrogen fraction used by the
/// standard air blend.
///
/// - Since: 1.0.0
public struct Trace: GasRepresentable, Sendable {
    /// Creates a trace gas value.
    ///
    /// - Since: 1.0.0
    public init() {}
}

public extension GasRepresentable where Self == Trace {
    /// A convenience trace gas value.
    ///
    /// - Since: 1.0.0
    static var trace: Self {
        .init()
    }
}
