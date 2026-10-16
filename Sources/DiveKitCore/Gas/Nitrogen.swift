import Foundation

/// Nitrogen gas.
///
/// - Since: 1.0.0
public struct Nitrogen: GasRepresentable, Sendable {
    /// Creates a nitrogen gas value.
    ///
    /// - Since: 1.0.0
    public init() {}

    /// Nitrogen dissolves in tissue and is eliminated unchanged.
    ///
    /// - Since: 1.0.0
    public var metabolism: Metabolism {
        .inert
    }

    /// Nitrogen is the reference gas for narcotic potency.
    ///
    /// - Since: 1.0.0
    public var narcoticPotency: NarcoticPotency {
        .nitrogen
    }
}

public extension GasRepresentable where Self == Nitrogen {
    /// A convenience nitrogen gas value.
    ///
    /// - Since: 1.0.0
    static var nitrogen: Self {
        .init()
    }
}
