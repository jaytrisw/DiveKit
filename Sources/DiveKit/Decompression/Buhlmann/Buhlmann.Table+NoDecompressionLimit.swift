import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann.Table {
    /// Returns how long the compartments can stay at a constant depth before a ceiling forms.
    ///
    /// Each whole minute from `1` to `999` loads the starting compartments for
    /// that duration and checks that every compartment still tolerates the
    /// surface, at one atmosphere. The limit is the last whole minute before
    /// the first check that fails. Ascent time is not included.
    ///
    /// A compartment whose gases load in opposite directions at the start, such
    /// as nitrogen off-gassing while helium on-gasses, can briefly have a
    /// ceiling that clears again, so it is also checked every second. A
    /// ceiling that forms and clears between checks is not detected.
    ///
    /// Inspired pressures are calculated as for
    /// ``Tissue/Inspired/init(of:breathing:at:waterVapor:configuration:)``.
    /// Inert gases in `blend` that a compartment does not track are ignored
    /// without being reported, unlike
    /// ``Tissue/Compartment/loaded(for:inspired:using:)``. That covers air's
    /// trace gases, but also helium for a nitrogen-only compartment breathing
    /// trimix: the compartment takes up none of that gas, so its limit is longer.
    ///
    /// - Parameters:
    ///   - compartments: The compartments at the start of the segment, in any order.
    ///   - depth: The depth, in the configured units.
    ///   - blend: The breathing gas.
    ///   - gradientFactor: The gradient factor. Defaults to
    ///     ``GradientFactor/full``.
    ///   - waterVapor: The alveolar water vapor pressure in atmospheres.
    ///     Defaults to ``Tissue/alveolarWaterVapor``.
    ///   - configuration: The units and water used to convert depth to pressure.
    ///   - model: The loading equation. Defaults to ``Tissue/Loading/schreiner``.
    /// - Returns: The limit in whole minutes, rounded down; `.unlimited` if no
    ///   ceiling forms within 999 minutes; or `.exceeded` if a compartment
    ///   already has a ceiling below the surface.
    /// - Throws: `Error.negative` if `depth` or `waterVapor` is negative;
    ///   `Error.range` if either is not finite, if the configured water's depth
    ///   per atmosphere is not finite or not greater than `0`, or if the
    ///   ambient pressure at `depth` or a tolerated pressure is not finite;
    ///   `Error.gas` if no single row covers every gas a compartment tracks, as
    ///   for ``ceiling(of:gradientFactor:configuration:)``; or the errors of
    ///   ``Tissue/Compartment/loaded(for:inspired:using:)`` if `model` returns
    ///   an invalid tension.
    ///
    /// ```swift
    /// let compartments = try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
    /// let limit = try Buhlmann.Table.zhl16c.noDecompressionLimit(
    ///     of: compartments,
    ///     at: .init(30),
    ///     breathing: .air,
    ///     gradientFactor: try .init(0.85),
    ///     configuration: .init(units: .metric, water: .salt))
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    /// - Since: 1.0.0
    func noDecompressionLimit(
        of compartments: [Tissue.Compartment],
        at depth: Depth,
        breathing blend: Blend<Blended>,
        gradientFactor: GradientFactor = .full,
        waterVapor: Pressure = Tissue.alveolarWaterVapor,
        configuration: Configuration,
        using model: Tissue.Loading = .schreiner) throws(Error) -> NoDecompressionLimit {
            try noDecompressionLimit(
                of: compartments,
                at: depth,
                breathing: blend,
                gradientFactor: gradientFactor,
                waterVapor: waterVapor,
                configuration: configuration,
                using: model,
                .from(Self.self))
        }
}

extension Buhlmann.Table {
    /// Returns how long the compartments can stay at a constant depth before a
    /// ceiling forms, reporting errors at `callSite`.
    func noDecompressionLimit(
        of compartments: [Tissue.Compartment],
        at depth: Depth,
        breathing blend: Blend<Blended>,
        gradientFactor: GradientFactor = .full,
        waterVapor: Pressure = Tissue.alveolarWaterVapor,
        configuration: Configuration,
        using model: Tissue.Loading = .schreiner,
        _ callSite: CallSite) throws(Error) -> NoDecompressionLimit {
            let breathed = try Tissue.breathedPressure(
                at: depth,
                waterVapor: waterVapor,
                configuration: configuration,
                callSite)
            let fractions = blend.fractions

            // Matching a compartment to its row is the costly part and doesn't depend on
            // tension, so match every compartment once.
            let matched = try compartments.map { (compartment: Tissue.Compartment) throws(Error) in
                try matchedGases(of: compartment, callSite).map { matched in
                    (matched: matched, fraction: fractions[matched.gas] ?? .zero)
                }
            }

            /// Returns whether any of `compartments` has a ceiling below the surface after `minutes`.
            func hasCeiling(
                _ compartments: [[(matched: MatchedGas, fraction: Double)]],
                after minutes: Double) throws(Error) -> Bool {
                    // Check every compartment so an invalid model tension throws regardless of order.
                    var hasCeiling = false
                    for compartment in compartments {
                        let tensions = try compartment.map { (gas) throws(Error) in
                            (limit: gas.matched.limit,
                             tension: minutes > 0
                                ? try gas.matched.entry.loaded(for: minutes, fraction: gas.fraction, breathed: (breathed, breathed), using: model, callSite).tension
                                : gas.matched.entry.tension)
                        }
                        if try Self.toleratedAmbientPressure(of: tensions, gradientFactor: gradientFactor, callSite).value > Surface.pressure {
                            hasCeiling = true
                        }
                    }
                    return hasCeiling
                }

            let counterDiffusing = matched.filter { compartment in
                Set(compartment.compactMap { gas in
                    let inspired = breathed * gas.fraction
                    return inspired == gas.matched.entry.tension ? nil : inspired > gas.matched.entry.tension
                }).count > 1
            }

            guard try !hasCeiling(matched, after: .zero) else { return .exceeded }
            for minute in 1...999 {
                let previous = Double(minute - 1)
                if !counterDiffusing.isEmpty {
                    for second in 1..<60 where try hasCeiling(counterDiffusing, after: previous + Double(second) / 60) {
                        return .minutes(.init(previous))
                    }
                }
                if try hasCeiling(matched, after: Double(minute)) {
                    return .minutes(.init(previous))
                }
            }
            return .unlimited
        }
}
