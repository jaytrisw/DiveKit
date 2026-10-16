import Foundation

/// Argon gas.
///
/// Argon makes up about 0.93% of dry air.
///
/// - Since: 1.0.0
public struct Argon: GasRepresentable, Sendable {
    /// Creates an argon gas value.
    ///
    /// - Since: 1.0.0
    public init() {}

    /// Argon dissolves in tissue and is eliminated unchanged.
    ///
    /// - Since: 1.0.0
    public var metabolism: Metabolism {
        .inert
    }

    /// Argon is about 2.3 times as narcotic as nitrogen (Bennett, 2004).
    ///
    /// - Since: 1.0.0
    public var narcoticPotency: NarcoticPotency {
        .relative(2.3)
    }
}

public extension GasRepresentable where Self == Argon {
    /// A convenience argon gas value.
    ///
    /// - Since: 1.0.0
    static var argon: Self {
        .init()
    }
}
