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
    /// the first check that fails. A compartment whose gases load in opposite
    /// directions at the start, such as nitrogen off-gassing while helium
    /// on-gasses, can briefly have a ceiling that clears again, so it is also
    /// checked every second. A ceiling that forms and clears between checks is
    /// not detected.
    /// Inspired pressures are calculated as for
    /// ``Tissue/Inspired/init(of:breathing:at:waterVapour:configuration:)``.
    /// Inert gases in `blend` that a compartment does not track, such as air's
    /// trace gases, are ignored. Ascent time is not included.
    ///
    /// - Parameters:
    ///   - compartments: The compartments at the start of the segment, in any order.
    ///   - depth: The depth, in the configured units.
    ///   - blend: The breathing gas.
    ///   - gradientFactor: The gradient factor. Defaults to
    ///     ``Buhlmann/GradientFactor/full``.
    ///   - waterVapour: The alveolar water vapour pressure in atmospheres.
    ///     Defaults to ``Tissue/alveolarWaterVapour``.
    ///   - configuration: The units and water used to convert depth to pressure.
    ///   - model: The loading equation. Defaults to ``Tissue/Loading/schreiner``.
    /// - Returns: The limit in whole minutes, rounded down; `.unlimited` if no
    ///   ceiling forms within 999 minutes; or `.exceeded` if a compartment
    ///   already has a ceiling below the surface.
    /// - Throws: `Error.negative` if `depth` or `waterVapour` is negative, or
    ///   `Error.range` if either is not finite or a tolerated pressure is not
    ///   finite. Also throws `Error.gas` if no single row covers every gas a
    ///   compartment tracks, as for
    ///   ``toleratedAmbientPressure(of:gradientFactor:)``, and the errors of
    ///   ``Tissue/Compartment/loaded(for:inspired:using:)`` if `model` returns an
    ///   invalid tension.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
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
    /// - Since: 1.0.0
    func noDecompressionLimit(
        of compartments: [Tissue.Compartment],
        at depth: Depth,
        breathing blend: Blend<Blended>,
        gradientFactor: Buhlmann.GradientFactor = .full,
        waterVapour: Pressure = Tissue.alveolarWaterVapour,
        configuration: Configuration,
        using model: Tissue.Loading = .schreiner) throws(Error) -> Buhlmann.NoDecompressionLimit {
            let callSite: CallSite = .from(Self.self)
            let breathed = try Tissue.breathedPressure(
                at: depth,
                waterVapour: waterVapour,
                configuration: configuration,
                callSite)
            let fractions = Dictionary(blend.components().map { (AnyGas($0), blend.fractionalPressure(of: $0)) }) { $1 }

            // Matching a compartment to its row is the costly part and doesn't depend on
            // tension, so match every compartment once.
            let matched = try compartments.map { (compartment: Tissue.Compartment) throws(Error) in
                try limits(of: compartment, callSite).map { matched in
                    (matched: matched, inspired: breathed * (fractions[matched.gas] ?? .zero))
                }
            }

            /// Returns whether any of `compartments` has a ceiling below the surface after `minutes`.
            func hasCeiling(
                _ compartments: [[(matched: MatchedGas, inspired: Double)]],
                after minutes: Double) throws(Error) -> Bool {
                    // Check every compartment so an invalid model tension throws regardless of order.
                    var hasCeiling = false
                    for compartment in compartments {
                        let tensions = try compartment.map { (gas) throws(Error) in
                            (limit: gas.matched.limit,
                             tension: minutes > 0
                                ? try gas.matched.entry.loaded(for: minutes, inspired: (gas.inspired, gas.inspired), using: model, callSite).tension
                                : gas.matched.entry.tension)
                        }
                        if try Self.toleratedAmbientPressure(of: tensions, gradientFactor: gradientFactor, callSite).value > 1 {
                            hasCeiling = true
                        }
                    }
                    return hasCeiling
                }

            let counterDiffusing = matched.filter { compartment in
                Set(compartment.compactMap { gas in
                    gas.inspired == gas.matched.entry.tension ? nil : gas.inspired > gas.matched.entry.tension
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
