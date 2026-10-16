import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann.Table {
    /// Returns the lowest ambient pressure a compartment tolerates.
    ///
    /// The compartment is matched to the first row whose coefficients cover every
    /// gas it tracks at the gas's half-time; gases are never matched across rows.
    /// Half-times must be equal exactly, as they are for compartments built with
    /// ``compartments(nitrogen:helium:)``.
    /// With several inert gases, `a` and `b` are
    /// averaged, weighted by each gas's tension. The tolerated pressure with
    /// gradient factor `GF` is `(P − a·GF) / (GF / b − GF + 1)`, where `P` is the
    /// total inert-gas tension. At `GF = 1` this is Bühlmann's `(P − a) · b`.
    ///
    /// - Parameters:
    ///   - compartment: The compartment to check.
    ///   - gradientFactor: The gradient factor. Defaults to
    ///     ``Buhlmann/GradientFactor/full``.
    /// - Returns: The tolerated ambient pressure in atmospheres, or `0` if the
    ///   compartment holds no inert gas or tolerates any ambient pressure.
    /// - Throws: `Error.gas` if no single row covers every tracked gas at its
    ///   half-time. Gases are checked in order of their module-qualified type
    ///   name, and the first that matches no row shared with the gases before it
    ///   is reported. Throws `Error.range` if the tolerated pressure is not finite.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// ```swift
    /// let tolerated = try Buhlmann.Table.zhl16c.toleratedAmbientPressure(
    ///     of: compartment,
    ///     gradientFactor: try .init(0.85))
    /// ```
    ///
    /// - Since: 1.0.0
    func toleratedAmbientPressure(
        of compartment: Tissue.Compartment,
        gradientFactor: Buhlmann.GradientFactor = .full) throws(Error) -> Pressure {
            try toleratedAmbientPressure(of: compartment, gradientFactor: gradientFactor, .from(Self.self))
        }

    /// Returns the shallowest depth every compartment tolerates.
    ///
    /// The controlling compartment is the one with the highest
    /// ``toleratedAmbientPressure(of:gradientFactor:)``. Its pressure is
    /// converted to depth using the configured water and units, with the surface
    /// at one atmosphere.
    ///
    /// - Parameters:
    ///   - compartments: The compartments to check, in any order.
    ///   - gradientFactor: The gradient factor. Defaults to
    ///     ``Buhlmann/GradientFactor/full``.
    ///   - configuration: The units and water used for the resulting depth.
    /// - Returns: A calculation containing the ceiling depth, or `0` if every
    ///   compartment tolerates the surface.
    /// - Throws: `Error.gas` if no single row covers every gas a compartment
    ///   tracks, as for ``toleratedAmbientPressure(of:gradientFactor:)``, or
    ///   `Error.range` if the tolerated pressure or the ceiling depth is not finite.
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
        gradientFactor: Buhlmann.GradientFactor = .full,
        configuration: Configuration) throws(Error) -> Calculation<DecimalResult<Depth>> {
            let callSite: CallSite = .from(Self.self)
            let tolerated = try compartments
                .map { (compartment: Tissue.Compartment) throws(Error) in
                    try toleratedAmbientPressure(of: compartment, gradientFactor: gradientFactor, callSite).value
                }
                .reduce(.zero, Swift.max)
            let gauge = Swift.max(tolerated - .one, .zero)
            let depth = try (gauge * configuration.water.pressure(configuration.units).increase.value)
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
            return .decimal(depth, unit: \.depth, from: configuration)
        }
}

extension Buhlmann.Table {
    /// Returns the tolerated ambient pressure, reporting errors at `callSite`.
    func toleratedAmbientPressure(
        of compartment: Tissue.Compartment,
        gradientFactor: Buhlmann.GradientFactor,
        _ callSite: CallSite) throws(Error) -> Pressure {
            let tracked = compartment.storage
                .map { (key: LimitKey(gas: $0.key, halfTime: $0.value.halfTime), tension: $0.value.tension) }
                .sorted { $0.key.qualifiedTypeName < $1.key.qualifiedTypeName }
            var candidates = Array(rowLimits.indices)
            for entry in tracked {
                candidates = candidates.filter { rowLimits[$0][entry.key] != nil }
                guard !candidates.isEmpty else {
                    throw .gas(.unmodeled(entry.key.gas.gas.forceUnwrap("Tracked gases are always GasRepresentable.")), callSite)
                }
            }
            guard let row = candidates.first else { return .init(.zero) }
            let entries = tracked.map { entry in
                (limit: rowLimits[row][entry.key].forceUnwrap("Every candidate row covers every tracked gas."), tension: entry.tension)
            }
            // Scale by the largest tension so the sum and weights cannot overflow.
            let largest = entries.reduce(.zero) { Swift.max($0, $1.tension) }
            guard largest > 0 else { return .init(.zero) }
            let scaledTotal = entries.reduce(.zero) { $0 + $1.tension / largest }
            let weighted = entries.reduce((a: Double.zero, b: Double.zero)) { sum, entry in
                let weight = entry.tension / largest / scaledTotal
                return (sum.a + entry.limit.coefficientA * weight, sum.b + entry.limit.coefficientB * weight)
            }
            let factor = gradientFactor.value
            // `b` is in (0, 1] and `factor` is in (0, 1], so the divisor is at least 1.
            let tolerated = try (largest * ((scaledTotal - weighted.a * factor / largest) / (factor / weighted.b - factor + 1)))
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
            return .init(Swift.max(tolerated, .zero))
        }
}
