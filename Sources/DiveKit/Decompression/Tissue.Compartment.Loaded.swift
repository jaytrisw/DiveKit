import Foundation
import DiveKitCore

@_spi(Experimental)
public extension Tissue.Compartment {
    /// The outcome of loading a compartment over a segment.
    ///
    /// Switch over the result to get the updated compartment, so inspired gases the
    /// compartment does not track are never ignored silently.
    ///
    /// - Since: 1.0.0
    enum Loaded: Sendable {
        /// Every inspired inert gas was tracked by the compartment.
        ///
        /// - Parameter compartment: The updated compartment.
        /// - Since: 1.0.0
        case tracked(_ compartment: Tissue.Compartment)

        /// Some inspired inert gases are not tracked by the compartment and were ignored.
        ///
        /// - Parameters:
        ///   - compartment: The updated compartment.
        ///   - gases: The inspired inert gases the compartment does not track.
        /// - Since: 1.0.0
        case untracked(_ compartment: Tissue.Compartment, gases: [any GasRepresentable])
    }
}
