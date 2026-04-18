import Foundation

/// Nitrogen gas.
///
/// - Since: 1.0.0
public struct Nitrogen: GasRepresentable, Sendable {
    /// Creates a nitrogen gas value.
    ///
    /// - Since: 1.0.0
    public init() {}
}

public extension GasRepresentable where Self == Nitrogen {
    /// A convenience nitrogen gas value.
    ///
    /// - Since: 1.0.0
    static var nitrogen: Self {
        .init()
    }
}
