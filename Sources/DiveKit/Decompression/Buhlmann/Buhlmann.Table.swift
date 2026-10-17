import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann {
    /// A set of nitrogen and helium coefficients, one row per compartment.
    ///
    /// Tables are plain values: use a built-in table such as ``zhl16c`` or
    /// create your own from rows. Compartment state is a plain
    /// ``Tissue/Compartment``; the table matches each compartment to the row
    /// whose half-times its tracked gases share exactly, so compartments can be loaded
    /// with ``Tissue/Compartment/loaded(for:inspired:using:)`` and checked against
    /// the table in any order.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Table: Sendable, Equatable {
        /// The table's rows, fastest compartment first.
        ///
        /// - Since: 1.0.0
        public let rows: [Row]

        /// Each row's coefficients keyed by gas and half-time, derived from ``rows``.
        let rowLimits: [[LimitKey: Limit]]

        /// Creates a table from rows.
        ///
        /// If several rows match a compartment, the first is used.
        ///
        /// - Parameter rows: The table's rows, fastest compartment first.
        ///
        /// - Warning: See ``Buhlmann`` before relying on this model.
        ///
        /// ```swift
        /// let table = Buhlmann.Table([
        ///     .init(
        ///         nitrogen: try .init(of: .nitrogen, halfTime: .init(5), a: .init(1.1543), b: 0.5578),
        ///         helium: try .init(of: .helium, halfTime: .init(1.88), a: .init(1.5977), b: 0.4770))
        /// ])
        /// ```
        ///
        /// - Since: 1.0.0
        public init(_ rows: [Row]) {
            self.rows = rows
            rowLimits = rows.map { row in
                [.init(row.nitrogen): .init(row.nitrogen), .init(row.helium): .init(row.helium)]
            }
        }
    }
}

@_spi(Experimental)
public extension Buhlmann.Table {
    /// One compartment's nitrogen and helium coefficients.
    ///
    /// Every row models both gases. Do not fill in placeholder helium
    /// coefficients to build a nitrogen-only table: a helium-tracking
    /// compartment whose half-time matches a placeholder uses it instead of
    /// throwing `Error.gas`.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Row: Sendable, Equatable {
        /// The nitrogen coefficients.
        ///
        /// - Since: 1.0.0
        public let nitrogen: Buhlmann.Coefficients<Nitrogen>

        /// The helium coefficients.
        ///
        /// - Since: 1.0.0
        public let helium: Buhlmann.Coefficients<Helium>

        /// Creates a row.
        ///
        /// - Parameters:
        ///   - nitrogen: The nitrogen coefficients.
        ///   - helium: The helium coefficients.
        ///
        /// - Warning: See ``Buhlmann`` before relying on this model.
        ///
        /// ```swift
        /// let row = Buhlmann.Table.Row(
        ///     nitrogen: try .init(of: .nitrogen, halfTime: .init(5), a: .init(1.1543), b: 0.5578),
        ///     helium: try .init(of: .helium, halfTime: .init(1.88), a: .init(1.5977), b: 0.4770))
        /// ```
        ///
        /// - Since: 1.0.0
        public init(nitrogen: Buhlmann.Coefficients<Nitrogen>, helium: Buhlmann.Coefficients<Helium>) {
            self.nitrogen = nitrogen
            self.helium = helium
        }
    }

    /// Returns one compartment per row, each starting at the same tensions.
    ///
    /// - Parameters:
    ///   - nitrogen: The initial dissolved nitrogen tension in atmospheres.
    ///   - helium: The initial dissolved helium tension in atmospheres. Defaults to `0`.
    /// - Returns: The compartments, in row order, each tracking nitrogen and
    ///   helium with the row's half-times.
    /// - Throws: `Error.negative` if either tension is negative, or
    ///   `Error.range` if either is not finite, even when the table has no rows.
    ///
    /// ```swift
    /// let compartments = try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    func compartments(
        nitrogen: PartialPressure<Nitrogen>,
        helium: PartialPressure<Helium> = .init(.zero)) throws(Error) -> [Tissue.Compartment] {
            let callSite: CallSite = .from(Self.self)
            let nitrogen = try nitrogen
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
            let helium = try helium
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
            var compartments: [Tissue.Compartment] = []
            compartments.reserveCapacity(rows.count)
            for row in rows {
                compartments.append(.init(
                    try .init(of: row.nitrogen.gas, halfTime: row.nitrogen.halfTime, tension: nitrogen),
                    try .init(of: row.helium.gas, halfTime: row.helium.halfTime, tension: helium)))
            }
            return compartments
        }

    /// Bühlmann's ZH-L16C table, using compartment 1b (5 minutes for nitrogen).
    ///
    /// ZH-L16C has more conservative nitrogen `a` values in the middle
    /// compartments than ZH-L16A and is the variant intended for dive
    /// computers. Values are from A. A. Bühlmann, *Tauchmedizin* (2002), as
    /// published in bar and converted to atmospheres. They were cross-checked
    /// against Subsurface's `core/deco.cpp`.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    static let zhl16c: Self = .init([
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 5.0, bar: 1.1696, b: 0.5578),
            helium: .init(Helium(), halfTime: 1.88, bar: 1.6189, b: 0.4770)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 8.0, bar: 1.0000, b: 0.6514),
            helium: .init(Helium(), halfTime: 3.02, bar: 1.3830, b: 0.5747)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 12.5, bar: 0.8618, b: 0.7222),
            helium: .init(Helium(), halfTime: 4.72, bar: 1.1919, b: 0.6527)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 18.5, bar: 0.7562, b: 0.7825),
            helium: .init(Helium(), halfTime: 6.99, bar: 1.0458, b: 0.7223)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 27.0, bar: 0.6200, b: 0.8126),
            helium: .init(Helium(), halfTime: 10.21, bar: 0.9220, b: 0.7582)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 38.3, bar: 0.5043, b: 0.8434),
            helium: .init(Helium(), halfTime: 14.48, bar: 0.8205, b: 0.7957)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 54.3, bar: 0.4410, b: 0.8693),
            helium: .init(Helium(), halfTime: 20.53, bar: 0.7305, b: 0.8279)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 77.0, bar: 0.4000, b: 0.8910),
            helium: .init(Helium(), halfTime: 29.11, bar: 0.6502, b: 0.8553)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 109.0, bar: 0.3750, b: 0.9092),
            helium: .init(Helium(), halfTime: 41.20, bar: 0.5950, b: 0.8757)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 146.0, bar: 0.3500, b: 0.9222),
            helium: .init(Helium(), halfTime: 55.19, bar: 0.5545, b: 0.8903)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 187.0, bar: 0.3295, b: 0.9319),
            helium: .init(Helium(), halfTime: 70.69, bar: 0.5333, b: 0.8997)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 239.0, bar: 0.3065, b: 0.9403),
            helium: .init(Helium(), halfTime: 90.34, bar: 0.5189, b: 0.9073)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 305.0, bar: 0.2835, b: 0.9477),
            helium: .init(Helium(), halfTime: 115.29, bar: 0.5181, b: 0.9122)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 390.0, bar: 0.2610, b: 0.9544),
            helium: .init(Helium(), halfTime: 147.42, bar: 0.5176, b: 0.9171)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 498.0, bar: 0.2480, b: 0.9602),
            helium: .init(Helium(), halfTime: 188.24, bar: 0.5172, b: 0.9217)),
        .init(
            nitrogen: .init(Nitrogen(), halfTime: 635.0, bar: 0.2327, b: 0.9653),
            helium: .init(Helium(), halfTime: 240.03, bar: 0.5119, b: 0.9267))
    ])
}

extension Buhlmann.Table {
    /// One gas's coefficients with the gas type erased.
    struct Limit: Sendable, Equatable {
        let coefficientA: Double
        let coefficientB: Double

        init(_ coefficients: Buhlmann.Coefficients<some GasRepresentable>) {
            coefficientA = coefficients.coefficientA.value
            coefficientB = coefficients.coefficientB
        }
    }

    /// Identifies coefficients by gas and half-time.
    struct LimitKey: Sendable, Hashable {
        let gas: AnyGas
        let halfTime: Minutes

        init(_ coefficients: Buhlmann.Coefficients<some GasRepresentable>) {
            self.init(gas: .init(coefficients.gas), halfTime: coefficients.halfTime)
        }

        init(gas: AnyGas, halfTime: Minutes) {
            self.gas = gas
            self.halfTime = halfTime
        }

        /// The gas's module-qualified type name, used to check gases in a stable order.
        var qualifiedTypeName: String {
            String(reflecting: type(of: gas.value.base))
        }
    }
}
