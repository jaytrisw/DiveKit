import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue {
    /// Nitrogen and helium loading in one theoretical tissue compartment.
    ///
    /// All partial pressures are in atmospheres and durations are in minutes.
    /// Inspired pressures are supplied by the caller; this type does not derive
    /// them from depth, breathing-gas fractions, or water vapour pressure.
    /// The model tracks dissolved inert gas only. It does not compute ceilings,
    /// no-decompression limits, or a safe ascent schedule.
    ///
    /// - Since: 1.1.0
    struct Compartment: Sendable, Equatable {
        /// The gas-specific half-times for this compartment.
        ///
        /// - Since: 1.1.0
        public let halfTimes: HalfTimes

        /// The dissolved nitrogen tension in atmospheres.
        ///
        /// - Since: 1.1.0
        public let nitrogen: PartialPressure<Nitrogen>

        /// The dissolved helium tension in atmospheres.
        ///
        /// - Since: 1.1.0
        public let helium: PartialPressure<Helium>

        /// Creates a compartment with gas-specific half-times and initial tensions.
        ///
        /// - Parameters:
        ///   - halfTimes: The gas-specific half-times.
        ///   - nitrogen: The initial dissolved nitrogen tension in atmospheres.
        ///   - helium: The initial dissolved helium tension in atmospheres.
        /// - Throws: `Error.negative` if either tension is negative, or
        ///   `Error.range` if either tension is not finite.
        ///
        /// ```swift
        /// let compartment = try Tissue.Compartment(
        ///     halfTimes: halfTimes,
        ///     nitrogen: 0.74,
        ///     helium: 0)
        /// ```
        ///
        /// - Since: 1.1.0
        public init(
            halfTimes: HalfTimes,
            nitrogen: PartialPressure<Nitrogen>,
            helium: PartialPressure<Helium>) throws(Error) {
                let callSite: CallSite = .from(Self.self)
                self.init(
                    halfTimes,
                    try nitrogen
                        .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                        .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) },
                    try helium
                        .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                        .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) })
            }

        init(
            _ halfTimes: HalfTimes,
            _ nitrogen: PartialPressure<Nitrogen>,
            _ helium: PartialPressure<Helium>) {
                self.halfTimes = halfTimes
                self.nitrogen = nitrogen
                self.helium = helium
            }
    }
}
