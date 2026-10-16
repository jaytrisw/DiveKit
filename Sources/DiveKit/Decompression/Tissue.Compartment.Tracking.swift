import Foundation
import DiveKitCore

@_spi(Experimental)
public extension Tissue.Compartment {
    /// Whether a compartment models a gas.
    ///
    /// An untracked gas is different from a tracked gas with zero tension: the
    /// compartment has no half-time for it and ignores it when loading.
    ///
    /// - Since: 1.0.0
    enum Tracking<Gas: GasRepresentable>: Sendable, Equatable {
        /// The compartment models the gas.
        ///
        /// - Parameters:
        ///   - halfTime: The gas half-time in minutes.
        ///   - tension: The current dissolved tension in atmospheres.
        /// - Since: 1.0.0
        case tracked(halfTime: Minutes, tension: PartialPressure<Gas>)

        /// The compartment does not model the gas.
        ///
        /// - Since: 1.0.0
        case untracked
    }
}
