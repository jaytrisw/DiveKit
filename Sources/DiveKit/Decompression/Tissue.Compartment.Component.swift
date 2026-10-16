import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue.Compartment {
    /// A gas tracked by a compartment, with its half-time and dissolved tension.
    ///
    /// Only inert gases can be tracked.
    ///
    /// - Since: 1.0.0
    struct Component<Gas: GasRepresentable>: Sendable, Equatable {
        /// The tracked gas.
        ///
        /// - Since: 1.0.0
        public let gas: Gas

        /// The gas half-time in minutes.
        ///
        /// - Since: 1.0.0
        public let halfTime: Minutes

        /// The dissolved tension in atmospheres.
        ///
        /// - Since: 1.0.0
        public let tension: PartialPressure<Gas>

        /// Creates a tracked gas, validating its half-time and tension.
        ///
        /// - Parameters:
        ///   - gas: The tracked gas.
        ///   - halfTime: The gas half-time in minutes.
        ///   - tension: The initial dissolved tension in atmospheres.
        /// - Throws: `Error.gas` if `gas` is metabolic, `Error.range` if
        ///   `halfTime` is not greater than `0` or is not finite, `Error.negative`
        ///   if `tension` is negative, or `Error.range` if `tension` is not finite.
        ///
        /// ```swift
        /// let nitrogen = try Tissue.Compartment.Component(
        ///     of: .nitrogen,
        ///     halfTime: .init(5),
        ///     tension: .init(0.74))
        /// ```
        ///
        /// - Since: 1.0.0
        public init(
            of gas: Gas,
            halfTime: Minutes,
            tension: PartialPressure<Gas>) throws(Error) {
                let callSite: CallSite = .from(Self.self)
                guard gas.metabolism == .inert else { throw .gas(.metabolic(gas), callSite) }
                self.gas = gas
                self.halfTime = try halfTime
                    .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                    .validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), callSite) }
                self.tension = try tension
                    .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                    .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
            }
    }
}
