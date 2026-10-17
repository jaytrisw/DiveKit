import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann.Table {
    /// Returns the shallowest depth every compartment tolerates.
    ///
    /// Each compartment is matched to the first row whose coefficients cover
    /// every gas it tracks at the gas's half-time; gases are never matched
    /// across rows. Half-times must be equal exactly, as they are for
    /// compartments built with ``compartments(nitrogen:helium:)``. With several
    /// inert gases, `a` and `b` are averaged, weighted by each gas's tension.
    /// The tolerated ambient pressure with gradient factor `GF` is
    /// `(P − a·GF) / (GF / b − GF + 1)`, where `P` is the total inert-gas
    /// tension, clamped at `0`; at `GF = 1` this is Bühlmann's `(P − a) · b`. A
    /// compartment with no inert gas tolerates any pressure.
    ///
    /// The controlling compartment is the one with the highest tolerated
    /// pressure. Its pressure is converted to depth using the configured water
    /// and units, with the surface at one atmosphere.
    ///
    /// - Parameters:
    ///   - compartments: The compartments to check, in any order.
    ///   - gradientFactor: The gradient factor. Defaults to
    ///     ``GradientFactor/full``.
    ///   - configuration: The units and water used for the resulting depth.
    /// - Returns: A calculation containing the ceiling depth, or `0` if every
    ///   compartment tolerates the surface.
    /// - Throws: `Error.gas` if no single row covers every gas a compartment
    ///   tracks at its half-time. Gases are checked in order of their
    ///   module-qualified type name, and the first that matches no row shared
    ///   with the gases before it is reported. Throws `Error.range` if a
    ///   tolerated pressure or the ceiling depth is not finite,
    ///   or if the configured water's depth per atmosphere is not finite or not
    ///   greater than `0`.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// ```swift
    /// let ceiling = try Buhlmann.Table.zhl16c.ceiling(
    ///     of: compartments,
    ///     gradientFactor: try .init(0.85),
    ///     configuration: .init(units: .metric, water: .salt))
    /// ```
    ///
    /// - Since: 1.0.0
    func ceiling(
        of compartments: [Tissue.Compartment],
        gradientFactor: GradientFactor = .full,
        configuration: Configuration) throws(Error) -> Calculation<DecimalResult<Depth>> {
            try ceiling(
                of: compartments,
                gradientFactor: gradientFactor,
                configuration: configuration,
                .from(Self.self))
        }
}

extension Buhlmann.Table {
    /// Returns the shallowest depth every compartment tolerates, reporting errors at `callSite`.
    func ceiling(
        of compartments: [Tissue.Compartment],
        gradientFactor: GradientFactor,
        configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Depth>> {
            let increase = try configuration.pressureIncrease(callSite)
            let tolerated = try compartments
                .map { (compartment: Tissue.Compartment) throws(Error) in
                    try toleratedAmbientPressure(of: compartment, gradientFactor: gradientFactor, callSite).value
                }
                .reduce(.zero, Swift.max)
            let gauge = Swift.max(tolerated - .one, .zero)
            let depth = try (gauge * increase)
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
            return .decimal(depth, unit: \.depth, from: configuration)
        }

    /// Returns the lowest ambient pressure a compartment tolerates, as described for
    /// ``ceiling(of:gradientFactor:configuration:)``.
    func toleratedAmbientPressure(
        of compartment: Tissue.Compartment,
        gradientFactor: GradientFactor = .full) throws(Error) -> Pressure {
            try toleratedAmbientPressure(of: compartment, gradientFactor: gradientFactor, .from(Self.self))
        }

    /// Returns the tolerated ambient pressure, reporting errors at `callSite`.
    func toleratedAmbientPressure(
        of compartment: Tissue.Compartment,
        gradientFactor: GradientFactor,
        _ callSite: CallSite) throws(Error) -> Pressure {
            try Self.toleratedAmbientPressure(
                of: try matchedGases(of: compartment, callSite).map { (limit: $0.limit, tension: $0.entry.tension) },
                gradientFactor: gradientFactor,
                callSite)
        }

    /// Returns each tracked gas with its entry and the coefficients of the one row covering them all.
    ///
    /// The match depends only on gases and half-times, so it can be reused while tensions change.
    func matchedGases(
        of compartment: Tissue.Compartment,
        _ callSite: CallSite) throws(Error) -> [MatchedGas] {
            let tracked = compartment.storage
                .map { (key: LimitKey(gas: $0.key, halfTime: $0.value.halfTime), entry: $0.value) }
                .sorted { $0.key.gas.qualifiedTypeName < $1.key.gas.qualifiedTypeName }
            var candidates = Array(rowLimits.indices)
            for entry in tracked {
                candidates = candidates.filter { rowLimits[$0][entry.key] != nil }
                guard !candidates.isEmpty else {
                    throw .gas(.unmodeled(entry.key.gas.gas.forceUnwrap("Tracked gases are always GasRepresentable.")), callSite)
                }
            }
            guard let row = candidates.first else { return [] }
            return tracked.map { entry in
                .init(
                    gas: entry.key.gas,
                    entry: entry.entry,
                    limit: rowLimits[row][entry.key].forceUnwrap("Every candidate row covers every tracked gas."))
            }
        }

    /// A tracked gas with its entry and matched coefficients.
    struct MatchedGas {
        let gas: AnyGas
        let entry: Tissue.Compartment.Entry
        let limit: Limit
    }

    /// Returns the tolerated ambient pressure for tensions paired with their coefficients.
    static func toleratedAmbientPressure(
        of entries: [(limit: Limit, tension: Double)],
        gradientFactor: GradientFactor,
        _ callSite: CallSite) throws(Error) -> Pressure {
            // Scale by the largest tension so the sum and weights cannot overflow.
            let largest = entries.reduce(.zero) { Swift.max($0, $1.tension) }
            guard largest > 0 else { return .init(.zero) }
            let scaledTotal = entries.reduce(.zero) { $0 + $1.tension / largest }
            let sums = entries.reduce((a: Double.zero, b: Double.zero)) { sum, entry in
                let weight = entry.tension / largest / scaledTotal
                return (sum.a + entry.limit.coefficientA * weight, sum.b + entry.limit.coefficientB * weight)
            }
            // A weighted average lies within its inputs' range; clamping removes rounding,
            // such as weights summing above 1 overflowing a maximal `a`.
            let coefficientsA = entries.map(\.limit.coefficientA)
            let coefficientsB = entries.map(\.limit.coefficientB)
            let weighted = (
                a: Swift.min(Swift.max(sums.a, coefficientsA.min() ?? .zero), coefficientsA.max() ?? .zero),
                b: Swift.min(Swift.max(sums.b, coefficientsB.min() ?? .zero), coefficientsB.max() ?? .zero))
            let factor = gradientFactor.value
            // `b / (GF + (1 − GF)·b)` equals `1 / (GF / b − GF + 1)`. With `b` and
            // `factor` in [0.01, 1], it is in [0.01, 1].
            let ratio = weighted.b / (factor + (1 - factor) * weighted.b)
            let total = largest * scaledTotal
            // Only rescale when the total itself overflows; dividing `a` by a tiny
            // `largest` would overflow instead.
            let tolerated = try (total.isFinite
                ? (total - weighted.a * factor) * ratio
                : largest * ((scaledTotal - weighted.a * factor / largest) * ratio))
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
            return .init(Swift.max(tolerated, .zero))
        }
}
