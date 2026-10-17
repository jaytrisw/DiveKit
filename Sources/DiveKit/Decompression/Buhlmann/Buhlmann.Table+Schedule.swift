import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann.Table {
    /// Returns an ascent from depth to the surface, with decompression stops and gas switches.
    ///
    /// The ascent follows the rules of the decotengu planner:
    ///
    /// 1. If the compartments tolerate the surface at the high gradient factor
    ///    after a direct ascent on the starting gas, that ascent is the schedule.
    /// 2. Otherwise the diver repeatedly ascends to the ceiling at the low
    ///    gradient factor, rounded to the stop depth at or below it, until it
    ///    stops moving. That depth is the first stop. Gases are switched at their
    ///    exact switch depths on the way, unless, after ascending to the stop
    ///    depth at or above the switch, that stop would be above the ceiling at
    ///    the low gradient factor. If another switch comes before that stop,
    ///    the diver switches there first.
    /// 3. At each stop the diver waits whole minutes, at least one, until the
    ///    compartments tolerate the next stop at its gradient factor. The
    ///    gradient factor changes linearly from the low value at the first stop
    ///    to the high value at the surface. From the first stop on, gases are
    ///    switched at the first stop at or above their switch depths.
    ///
    /// Stops after the first are at ``Buhlmann/Ascent/lastStop`` and every
    /// ``Buhlmann/Ascent/stopInterval`` below it; the free ascent never goes
    /// shallower than the last stop. A gas whose switch depth is at or deeper
    /// than `depth` is breathed from the start instead of `blend`; if there are
    /// several, the shallowest is used. A gas whose switch depth is shallower
    /// than the last stop is never used. Inspired pressures are calculated as
    /// for ``Tissue/Inspired/init(of:breathing:from:to:waterVapor:configuration:)``,
    /// and inert gases a compartment does not track are ignored, as for
    /// ``noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)``.
    ///
    /// Decisions use the compartments at the start of a move or the end of a
    /// stop minute. A ceiling that forms and clears during a move or within a
    /// minute, as can happen when gases load in opposite directions after a
    /// switch, is not detected. The schedule never descends. If the diver cannot
    /// leave `depth`, because the ceiling at the low gradient factor rounds to a
    /// stop at or below it or because `depth` is shallower than the last stop,
    /// `depth` is the first stop, even off the stop grid.
    ///
    /// - Parameters:
    ///   - compartments: The compartments at the end of the bottom phase, in any order.
    ///   - depth: The depth at the start of the ascent, in the configured units.
    ///   - blend: The gas breathed at the start of the ascent.
    ///   - switches: Gases to switch to, keyed by switch depth in the configured units.
    ///   - gradientFactors: The gradient factors. Defaults to
    ///     ``Buhlmann/GradientFactors/full``.
    ///   - ascent: The ascent rate and stop depths.
    ///   - waterVapor: The alveolar water vapor pressure in atmospheres.
    ///     Defaults to ``Tissue/alveolarWaterVapor``.
    ///   - configuration: The units and water used to convert depth to pressure.
    ///   - model: The loading equation. Defaults to ``Tissue/Loading/schreiner``.
    /// - Returns: A calculation containing the schedule, which is empty if
    ///   `depth` is `0`.
    /// - Throws: `Error.negative` if `depth`, a switch depth, or `waterVapor` is
    ///   negative, or `Error.range` if any of them, or the ambient pressure at
    ///   any of them, is not finite. Also throws `Error.range` if the configured
    ///   water's depth per atmosphere is not finite or not greater than `0`.
    ///   Throws `Error.range` if the stops would take more than 999 minutes in
    ///   total. Also throws `Error.gas` if no
    ///   single row covers every gas a compartment tracks, as for
    ///   ``toleratedAmbientPressure(of:gradientFactor:)``, `Error.range` if a
    ///   tolerated pressure is not finite, and the errors of
    ///   ``Tissue/Compartment/loaded(for:inspired:using:)`` if `model` returns an
    ///   invalid tension.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// ```swift
    /// let schedule = try Buhlmann.Table.zhl16c.schedule(
    ///     of: compartments,
    ///     from: .init(40),
    ///     breathing: try .enrichedAir(0.21),
    ///     switches: [.init(21): try .enrichedAir(0.5), .init(6): try .enrichedAir(1)],
    ///     gradientFactors: try .init(low: try .init(0.3), high: try .init(0.85)),
    ///     ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(3)),
    ///     configuration: .init(units: .metric, water: .salt))
    /// ```
    ///
    /// - Since: 1.0.0
    func schedule(
        of compartments: [Tissue.Compartment],
        from depth: Depth,
        breathing blend: Blend<Blended>,
        switches: [Depth: Blend<Blended>] = [:],
        gradientFactors: Buhlmann.GradientFactors = .full,
        ascent: Buhlmann.Ascent,
        waterVapor: Pressure = Tissue.alveolarWaterVapor,
        configuration: Configuration,
        using model: Tissue.Loading = .schreiner) throws(Error) -> Calculation<Buhlmann.Schedule> {
            let callSite: CallSite = .from(Self.self)
            _ = try Tissue.breathedPressure(at: depth, waterVapor: waterVapor, configuration: configuration, callSite)
            let increase = try configuration.pressureIncrease(callSite)
            let switchDepths = switches.keys.sorted { $0.value > $1.value }
            for switchDepth in switchDepths {
                _ = try Tissue.breathedPressure(at: switchDepth, waterVapor: waterVapor, configuration: configuration, callSite)
            }
            let matched = try compartments.map { (compartment: Tissue.Compartment) throws(Error) in
                try matchedGases(of: compartment, callSite)
            }

            let start = switchDepths
                .last { $0.value >= depth.value }
                .flatMap { switches[$0] }
                .map { Buhlmann.Planner.Gas($0, switchDepth: nil) } ?? .init(blend, switchDepth: nil)
            let gases = switchDepths
                .filter { $0.value < depth.value && $0.value >= ascent.lastStop.value }
                .compactMap { switchDepth in switches[switchDepth].map { Buhlmann.Planner.Gas($0, switchDepth: switchDepth.value) } }

            let planner = Buhlmann.Planner(
                gradientFactors: gradientFactors,
                grid: .init(interval: ascent.stopInterval.value, last: ascent.lastStop.value),
                rate: ascent.rate.value,
                waterVapor: waterVapor,
                configuration: configuration,
                increase: increase,
                model: model,
                callSite: callSite)
            return .init(
                result: .init(segments: try planner.schedule(of: matched, from: depth.value, breathing: start, switches: gases)),
                configuration: configuration)
        }
}
