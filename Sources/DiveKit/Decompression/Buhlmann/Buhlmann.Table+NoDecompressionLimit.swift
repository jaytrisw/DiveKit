import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann.Table {
    /// Returns how long the compartments can stay at a constant depth before a ceiling forms.
    ///
    /// Each whole minute from `1` to `999` loads the starting compartments for
    /// that duration and checks that every compartment still tolerates the
    /// surface, at one atmosphere. The limit is the last minute that does.
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
    ///   `Error.range` if either is not finite. Also throws `Error.gas` if no
    ///   single row covers every gas a compartment tracks, as for
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

            /// Returns whether any compartment has a ceiling below the surface after `minutes`.
            func hasCeiling(after minutes: Double) throws(Error) -> Bool {
                for compartment in compartments {
                    let loaded = minutes > 0
                        ? Tissue.Compartment(Dictionary(uniqueKeysWithValues: try compartment.storage.map { (gas, entry) throws(Error) in
                            let inspired = breathed * (fractions[gas] ?? .zero)
                            return (gas, try entry.loaded(for: minutes, inspired: (inspired, inspired), using: model, callSite))
                        }))
                        : compartment
                    if try toleratedAmbientPressure(of: loaded, gradientFactor: gradientFactor, callSite).value > 1 {
                        return true
                    }
                }
                return false
            }

            guard try !hasCeiling(after: .zero) else { return .exceeded }
            for minutes in 1...999 where try hasCeiling(after: Double(minutes)) {
                return .minutes(.init(Double(minutes - 1)))
            }
            return .unlimited
        }
}
