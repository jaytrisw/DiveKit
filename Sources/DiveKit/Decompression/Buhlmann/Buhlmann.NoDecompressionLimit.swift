import Foundation
import DiveKitCore

@_spi(Experimental)
public extension Buhlmann {
    /// How long a diver can stay at a depth and still ascend directly to the surface.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    enum NoDecompressionLimit: Sendable, Equatable {
        /// The whole minutes that can be spent at depth before a ceiling forms, rounded down.
        ///
        /// `.minutes(0)` means a ceiling forms within the next minute.
        ///
        /// - Since: 1.0.0
        case minutes(Minutes)

        /// No ceiling forms within 999 minutes.
        ///
        /// - Since: 1.0.0
        case unlimited

        /// A compartment already has a ceiling below the surface.
        ///
        /// - Since: 1.0.0
        case exceeded
    }
}
