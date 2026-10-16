import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann {
    /// One inert gas's Bühlmann coefficients in one compartment.
    ///
    /// The tolerated inert-gas tension at ambient pressure `P` is
    /// `a + P / b`. A smaller `b` and a larger `a` let the compartment hold more
    /// gas above ambient pressure.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Coefficients<Gas: GasRepresentable>: Sendable, Equatable {
        /// The gas these coefficients describe.
        ///
        /// - Since: 1.0.0
        public let gas: Gas

        /// The gas half-time in minutes.
        ///
        /// - Since: 1.0.0
        public let halfTime: Minutes

        /// Bühlmann's `a`: the tolerated tension at zero ambient pressure, in atmospheres.
        ///
        /// - Since: 1.0.0
        public let coefficientA: PartialPressure<Gas>

        /// Bühlmann's `b`: the reciprocal of the tolerated tension's slope against
        /// ambient pressure. Dimensionless, greater than `0` and at most `1`.
        ///
        /// - Since: 1.0.0
        public let coefficientB: Double

        /// Creates coefficients, validating each value.
        ///
        /// - Parameters:
        ///   - gas: The gas these coefficients describe.
        ///   - halfTime: The gas half-time in minutes.
        ///   - coefficientA: Bühlmann's `a`, in atmospheres. Published tables
        ///     give `a` in bar; divide by `1.01325` to convert.
        ///   - coefficientB: Bühlmann's `b`.
        /// - Throws: `Error.gas` if `gas` is metabolic, `Error.range` if
        ///   `halfTime` is not greater than `0` or is not finite, `Error.negative`
        ///   if `coefficientA` is negative, `Error.range` if `coefficientA` is not
        ///   finite, or `Error.range` if `coefficientB` is not greater than `0` or
        ///   is greater than `1`.
        ///
        /// ```swift
        /// let nitrogen = try Buhlmann.Coefficients(
        ///     of: .nitrogen,
        ///     halfTime: .init(5),
        ///     a: .init(1.1543),
        ///     b: 0.5578)
        /// ```
        ///
        /// - Since: 1.0.0
        public init(
            of gas: Gas,
            halfTime: Minutes,
            a coefficientA: PartialPressure<Gas>,
            b coefficientB: Double) throws(Error) {
                let callSite: CallSite = .from(Self.self)
                guard gas.metabolism == .inert else { throw .gas(.metabolic(gas), callSite) }
                self.gas = gas
                self.halfTime = try halfTime
                    .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                    .validate(using: .greater(than: 0)) { .range(.lowerBound($0.value, 0), callSite) }
                self.coefficientA = try coefficientA
                    .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                    .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                self.coefficientB = try coefficientB
                    .validate(using: .greater(than: 0)) { .range(.lowerBound($0, 0), callSite) }
                    .validate(using: .lessThanOrEqual(to: .one)) { .range(.upperBound($0, .one), callSite) }
            }

        /// Creates coefficients from a published table without validation.
        ///
        /// - Parameters:
        ///   - gas: The gas these coefficients describe.
        ///   - halfTime: The gas half-time in minutes.
        ///   - bar: Bühlmann's `a`, in bar as published.
        ///   - coefficientB: Bühlmann's `b`.
        init(_ gas: Gas, halfTime: Double, bar coefficientA: Double, b coefficientB: Double) {
            self.gas = gas
            self.halfTime = .init(halfTime)
            self.coefficientA = .init(coefficientA / Self.barPerAtmosphere)
            self.coefficientB = coefficientB
        }
    }
}

extension Buhlmann.Coefficients {
    /// The number of bar in one standard atmosphere.
    static var barPerAtmosphere: Double { 1.01325 }
}
