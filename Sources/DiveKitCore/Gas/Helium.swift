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
    /// narcotic depth. Bennett and Rostain (2003) rate it 0.045 times as
    /// narcotic as nitrogen (see ``NarcoticPotency``); opt in for a single
    /// calculation with `NarcoticTreatment`.
    ///
    /// - Since: 1.0.0
    public var narcoticPotency: NarcoticPotency {
        .none
    }
}
