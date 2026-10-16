import Foundation

/// Oxygen gas.
///
/// - Since: 1.0.0
public struct Oxygen: GasRepresentable, Sendable {
    /// Creates an oxygen gas value.
    ///
    /// - Since: 1.0.0
    public init() {}

    /// Oxygen is consumed by the body.
    ///
    /// - Since: 1.0.0
    public var metabolism: Metabolism {
        .metabolic
    }
}

public extension GasRepresentable where Self == Oxygen {
    /// A convenience oxygen gas value.
    ///
    /// - Since: 1.0.0
    static var oxygen: Self {
        .init()
    }
}
