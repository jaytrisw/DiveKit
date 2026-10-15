import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

/// Nitrogen and helium loading in one theoretical tissue compartment.
///
/// All partial pressures are in atmospheres and durations are in minutes.
/// Inspired pressures are supplied by the caller; this type does not derive
/// them from depth, breathing-gas fractions, or water vapour pressure.
/// The model tracks dissolved inert gas only. It does not compute ceilings,
/// no-decompression limits, or a safe ascent schedule.
///
/// - Since: 1.1.0
@_spi(Experimental)
public struct TissueCompartment: Sendable, Equatable {
    /// Uptake and elimination half-times for one compartment, in minutes.
    ///
    /// - Since: 1.1.0
    public struct HalfTimes: Sendable, Equatable {
        /// The nitrogen half-time.
        ///
        /// - Since: 1.1.0
        public let nitrogen: Minutes

        /// The helium half-time.
        ///
        /// - Since: 1.1.0
        public let helium: Minutes

        /// Creates half-times for both inert gases.
        ///
        /// - Parameters:
        ///   - nitrogen: The nitrogen half-time in minutes.
        ///   - helium: The helium half-time in minutes.
        /// - Throws: `Error.range` if either half-time is not greater than `0`
        ///   or is not finite.
        ///
        /// ```swift
        /// let halfTimes = try TissueCompartment.HalfTimes(nitrogen: 5, helium: 1.88)
        /// ```
        ///
        /// - Since: 1.1.0
        public init(nitrogen: Minutes, helium: Minutes) throws(Error) {
            let callSite = CallSite(object: .init(describing: Self.self), function: #function)
            self.nitrogen = try TissueCompartment.validated(halfTime: nitrogen, callSite)
            self.helium = try TissueCompartment.validated(halfTime: helium, callSite)
        }
    }

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
    /// let compartment = try TissueCompartment(
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
            let callSite = CallSite(object: .init(describing: Self.self), function: #function)
            self.init(
                halfTimes,
                try Self.validated(nitrogen, callSite),
                try Self.validated(helium, callSite))
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

extension TissueCompartment {
    static func validated(halfTime: Minutes, _ callSite: CallSite) throws(Error) -> Minutes {
        try halfTime.value
            .validate(using: .greater(than: .zero)) { .range(.lowerBound($0, .zero), callSite) }
            .validate(using: .lessThanOrEqual(to: .greatestFiniteMagnitude)) {
                .range(.upperBound($0, .greatestFiniteMagnitude), callSite)
            }
        return halfTime
    }

    static func validated(duration: Minutes, _ callSite: CallSite) throws(Error) -> Minutes {
        try duration.value
            .validate(using: .greaterThanOrEqual(to: .zero)) { .negative(.minutes(.init($0)), callSite) }
            .validate(using: .lessThanOrEqual(to: .greatestFiniteMagnitude)) {
                .range(.upperBound($0, .greatestFiniteMagnitude), callSite)
            }
        return duration
    }

    static func validated<Gas>(
        _ pressure: PartialPressure<Gas>,
        _ callSite: CallSite) throws(Error) -> PartialPressure<Gas> {
            try pressure.value
                .validate(using: .greaterThanOrEqual(to: .zero)) { .negative(.partialPressure($0), callSite) }
                .validate(using: .lessThanOrEqual(to: .greatestFiniteMagnitude)) {
                    .range(.upperBound($0, .greatestFiniteMagnitude), callSite)
                }
            return pressure
        }
}
