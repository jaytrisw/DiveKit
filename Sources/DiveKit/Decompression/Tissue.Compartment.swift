import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue {
    /// Inert-gas loading in one theoretical tissue compartment.
    ///
    /// A compartment tracks any number of gases, each with its own half-time and
    /// dissolved tension. All partial pressures are in atmospheres and durations
    /// are in minutes. Inspired pressures are supplied by the caller; this type
    /// does not derive them from depth, breathing-gas fractions, or water vapor
    /// pressure. The model tracks dissolved inert gas only. It does not compute
    /// ceilings, no-decompression limits, or a safe ascent schedule.
    ///
    /// - Since: 1.0.0
    struct Compartment: Sendable, Equatable {
        /// Storage keyed by type-erased gas identity.
        let storage: [AnyGas: Entry]

        /// Creates a compartment that tracks the given gases.
        ///
        /// If a gas appears more than once, the last component is used.
        ///
        /// - Parameter components: Each tracked gas with its half-time and
        ///   initial dissolved tension.
        ///
        /// ```swift
        /// let compartment = Tissue.Compartment(
        ///     try .init(of: .nitrogen, halfTime: .init(5), tension: .init(0.74)),
        ///     try .init(of: .helium, halfTime: .init(1.88), tension: .init(0)))
        /// ```
        ///
        /// - Since: 1.0.0
        public init<each Gas: GasRepresentable>(_ components: repeat Component<each Gas>) {
            var storage: [AnyGas: Entry] = [:]
            repeat storage[.init((each components).gas)] = .init(
                halfTime: (each components).halfTime,
                tension: (each components).tension.value)
            self.init(storage)
        }

        init(_ storage: [AnyGas: Entry]) {
            self.storage = storage
        }

        /// Returns whether a gas is tracked, with its half-time and tension.
        ///
        /// - Parameter gas: The gas to look up.
        /// - Returns: `.tracked` with the gas's half-time and current tension, or
        ///   `.untracked` if this compartment does not model the gas.
        /// - Since: 1.0.0
        public func tracking<Gas: GasRepresentable>(of gas: Gas) -> Tracking<Gas> {
            guard let entry = storage[.init(gas)] else { return .untracked }
            return .tracked(halfTime: entry.halfTime, tension: .init(entry.tension))
        }

        /// Returns the gases this compartment tracks.
        ///
        /// - Returns: The tracked gases, in no particular order.
        /// - Since: 1.0.0
        public func gases() -> [any GasRepresentable] {
            storage.keys.compactMap(\.gas)
        }
    }
}

extension Tissue.Compartment {
    struct Entry: Sendable, Equatable {
        let halfTime: Minutes
        let tension: Double
    }
}

/// Allows tissue compartments to be transformed with the internal mapping helpers.
///
/// - Since: 1.0.0
extension Tissue.Compartment: Mappable {}
