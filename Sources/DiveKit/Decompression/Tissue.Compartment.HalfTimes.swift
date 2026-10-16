import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue.Compartment {
    /// Uptake and elimination half-times for one compartment, in minutes.
    ///
    /// - Since: 1.1.0
    struct HalfTimes: Sendable, Equatable {
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
        /// let halfTimes = try Tissue.Compartment.HalfTimes(nitrogen: 5, helium: 1.88)
        /// ```
        ///
        /// - Since: 1.1.0
        public init(nitrogen: Minutes, helium: Minutes) throws(Error) {
            let callSite: CallSite = .from(Self.self)
            self.nitrogen = try nitrogen
                .validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), callSite) }
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
            self.helium = try helium
                .validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), callSite) }
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
        }
    }
}
