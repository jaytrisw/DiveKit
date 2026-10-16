import Foundation

/// Carbon dioxide gas.
///
/// Carbon dioxide makes up about 0.04% of dry air.
///
/// - Since: 1.0.0
public struct CarbonDioxide: GasRepresentable, Sendable {
    /// Creates a carbon dioxide gas value.
    ///
    /// - Since: 1.0.0
    public init() {}

    /// Carbon dioxide is produced by the body.
    ///
    /// - Since: 1.0.0
    public var metabolism: Metabolism {
        .metabolic
    }

    /// Carbon dioxide is about 20 times as narcotic as nitrogen (Bennett, 2004).
    ///
    /// - Since: 1.0.0
    public var narcoticPotency: NarcoticPotency {
        .relative(20)
    }
}

public extension GasRepresentable where Self == CarbonDioxide {
    /// A convenience carbon dioxide gas value.
    ///
    /// - Since: 1.0.0
    static var carbonDioxide: Self {
        .init()
    }
}
