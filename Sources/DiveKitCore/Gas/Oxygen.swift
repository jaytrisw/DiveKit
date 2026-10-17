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

    /// Oxygen is not narcotic by default. Bennett (2004) rates it about 1.7
    /// times as narcotic as nitrogen; opt in for a single calculation with
    /// `NarcoticTreatment`.
    ///
    /// - Since: 1.0.0
    public var narcoticPotency: NarcoticPotency {
        .none
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
