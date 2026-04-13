import Foundation

/// Oxygen gas.
///
/// - Since: 1.0.0
public struct Oxygen: GasRepresentable, Sendable {
    /// Creates an oxygen gas value.
    ///
    /// - Since: 1.0.0
    public init() {}
}

public extension GasRepresentable where Self == Oxygen {
    /// A convenience oxygen gas value.
    ///
    /// - Since: 1.0.0
    static var oxygen: Self {
        .init()
    }
}
