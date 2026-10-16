import Foundation

/// Helium gas.
///
/// - Since: 1.0.0
@_spi(Experimental)
public struct Helium: GasRepresentable, Sendable {
    /// Creates a helium gas value.
    ///
    /// - Since: 1.0.0
    public init() {}

    /// Helium dissolves in tissue and is eliminated unchanged.
    ///
    /// - Since: 1.0.0
    public var metabolism: Metabolism {
        .inert
    }

    /// Helium is treated as not narcotic, matching the standard equivalent
    /// narcotic depth. Bennett (2004) rates it about 0.2 times as narcotic as
    /// nitrogen; opt in for a single calculation with `NarcoticTreatment`.
    ///
    /// - Since: 1.0.0
    public var narcoticPotency: NarcoticPotency {
        .none
    }
}
