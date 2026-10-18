import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue {
    /// The inspired partial pressure of one gas over a segment.
    ///
    /// The pressure is either constant or changes linearly from the start to the
    /// end of the segment, as during a constant-rate ascent or descent. Pressures
    /// must already account for the caller's breathing model.
    ///
    /// - Since: 1.0.0
    struct Inspired<Gas: GasRepresentable>: Sendable, Equatable {
        /// The inspired gas.
        ///
        /// - Since: 1.0.0
        public let gas: Gas

        /// The inspired partial pressure at the start of the segment, in atmospheres.
        ///
        /// - Since: 1.0.0
        public let start: PartialPressure<Gas>

        /// The inspired partial pressure at the end of the segment, in atmospheres.
        ///
        /// - Since: 1.0.0
        public let end: PartialPressure<Gas>

        /// Creates a constant inspired pressure.
        ///
        /// - Parameters:
        ///   - gas: The inspired gas.
        ///   - pressure: The inspired partial pressure in atmospheres.
        /// - Throws: `Error.negative` if `pressure` is negative, or `Error.range`
        ///   if it is not finite.
        ///
        /// ```swift
        /// let nitrogen = try Tissue.Inspired(of: .nitrogen, pressure: .init(2.45))
        /// ```
        ///
        /// - Since: 1.0.0
        public init(of gas: Gas, pressure: PartialPressure<Gas>) throws(Error) {
            let callSite: CallSite = .from(Self.self)
            let pressure = try pressure
                .validatedFiniteNonNegative(callSite)
            self.gas = gas
            self.start = pressure
            self.end = pressure
        }

        /// Creates an inspired pressure that changes linearly over the segment.
        ///
        /// - Parameters:
        ///   - gas: The inspired gas.
        ///   - start: The inspired partial pressure at the start of the segment.
        ///   - end: The inspired partial pressure at the end of the segment.
        /// - Throws: `Error.negative` if either pressure is negative, or
        ///   `Error.range` if either is not finite.
        ///
        /// ```swift
        /// let descent = try Tissue.Inspired(
        ///     of: .nitrogen,
        ///     from: .init(0.74),
        ///     to: .init(2.45))
        /// ```
        ///
        /// - Since: 1.0.0
        public init(
            of gas: Gas,
            from start: PartialPressure<Gas>,
            to end: PartialPressure<Gas>) throws(Error) {
                let callSite: CallSite = .from(Self.self)
                self.gas = gas
                self.start = try start
                    .validatedFiniteNonNegative(callSite)
                self.end = try end
                    .validatedFiniteNonNegative(callSite)
            }
    }
}
