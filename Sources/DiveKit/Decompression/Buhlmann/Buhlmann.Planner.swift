import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

extension Buhlmann {
    /// Plans an ascent with the rules of decotengu's engine.
    ///
    /// Each step is named after the decotengu method it follows, so the two can
    /// be compared line by line.
    struct Planner {
        let gradientFactors: GradientFactors
        let grid: Grid
        let rate: Double
        /// The alveolar water vapor pressure in atmospheres, already validated.
        let waterVapor: Double
        /// The configured depth per atmosphere, already validated.
        let increase: Double
        let model: Tissue.Loading
        let callSite: CallSite

        /// The longest total stop time before a schedule is rejected, in minutes.
        static var maximumStopTime: Double { 999 }

        /// Returns the ascent from `depth` to the surface.
        func schedule(
            of compartments: [[Buhlmann.Table.MatchedGas]],
            from depth: Double,
            breathing start: Gas,
            switches: [Gas]) throws(Error) -> [DiveSegment] {
                guard depth > 0 else {
                    _ = try toleratedAmbientPressure(of: compartments, gradientFactor: gradientFactors.high)
                    return []
                }
                let diver = Diver(depth: depth, gas: start, compartments: compartments, segments: [])
                if let surfaced = try directAscent(from: diver) {
                    return surfaced.segments
                }
                return try decompressed(from: try freeAscent(from: diver, switches: switches), gases: [start] + switches).segments
            }
    }
}

extension Buhlmann.Planner {
    /// A breathing gas with its switch depth and inert-gas fractions.
    struct Gas {
        let blend: Blend<Blended>
        /// The switch depth in the configured units, or `nil` for the gas breathed at the start.
        let switchDepth: Double?
        let fractions: [AnyGas: Double]

        init(_ blend: Blend<Blended>, switchDepth: Double?) {
            self.blend = blend
            self.switchDepth = switchDepth
            fractions = blend.fractions
        }
    }

    /// The diver partway through the ascent.
    struct Diver {
        var depth: Double
        var gas: Gas
        var compartments: [[Buhlmann.Table.MatchedGas]]
        var segments: [DiveSegment]

        /// Appends a segment, joining consecutive ascents on the same blend.
        mutating func append(_ segment: DiveSegment) {
            if let last = segments.last,
               last.start != last.end,
               segment.start != segment.end,
               last.end == segment.start,
               last.blend == segment.blend {
                segments[segments.count - 1] = .init(
                    unchecked: last.start,
                    end: segment.end,
                    duration: .init(last.duration.value + segment.duration.value),
                    blend: segment.blend)
            } else {
                segments.append(segment)
            }
        }
    }

    /// Stop depths: `last + k·interval` for `k ≥ 0`, and the surface.
    struct Grid {
        let interval: Double
        let last: Double

        /// Returns the shallowest stop at or deeper than `depth`, or the surface for a depth at or above it.
        func roundedUp(_ depth: Double) -> Double {
            guard depth > 0 else { return .zero }
            guard depth > last else { return last }
            var index = ((depth - last) / interval).rounded(.up)
            // Correct for rounding in the division, so every stop rounds to itself.
            if index > 0, stop(at: index - 1) >= depth { index -= 1 }
            if stop(at: index) < depth { index += 1 }
            return stop(at: index)
        }

        /// Returns the deepest stop at or shallower than `depth`, or the surface for a depth above the last stop.
        func roundedDown(_ depth: Double) -> Double {
            guard depth >= last else { return .zero }
            var index = ((depth - last) / interval).rounded(.down)
            if stop(at: index + 1) <= depth { index += 1 }
            if index > 0, stop(at: index) > depth { index -= 1 }
            return stop(at: index)
        }

        /// Returns the deepest stop shallower than `depth`, or the surface.
        func stop(above depth: Double) -> Double {
            guard depth > last else { return .zero }
            var index = ((depth - last) / interval).rounded(.up) - 1
            if stop(at: index + 1) < depth { index += 1 }
            if index > 0, stop(at: index) >= depth { index -= 1 }
            return stop(at: Swift.max(index, .zero))
        }

        private func stop(at index: Double) -> Double {
            last + index * interval
        }
    }
}

extension Buhlmann.Planner {
    /// Returns the diver at the surface after a direct ascent on the starting gas,
    /// or `nil` if a compartment would not tolerate the surface at the high gradient factor.
    ///
    /// Follows decotengu's `_ndl_ascent`.
    func directAscent(from diver: Diver) throws(Error) -> Diver? {
        let surfaced = try moved(diver, to: .zero)
        return try toleratedAmbientPressure(of: surfaced.compartments, gradientFactor: gradientFactors.high) <= Surface.pressure ? surfaced : nil
    }

    /// Returns the diver at the first stop.
    ///
    /// The ascent is split into stages, one per gas, each ending at the next
    /// switch depth rounded to the stop at or below it; the last ends at the
    /// last stop. Follows decotengu's `_free_staged_ascent`.
    func freeAscent(from diver: Diver, switches: [Gas]) throws(Error) -> Diver {
        var diver = diver
        var remaining = switches[...]
        while true {
            let next = remaining.first
            let target = next?.switchDepth.map(grid.roundedUp) ?? grid.last
            diver = try ascendedToCeiling(diver, stoppingAt: target)
            guard diver.depth <= target, let next else { return diver }
            remaining.removeFirst()
            guard let switched = try switched(diver, to: next, before: remaining.first) else { return diver }
            diver = switched
        }
    }

    /// Returns the diver after repeatedly ascending to the low-gradient-factor
    /// ceiling, rounded to the stop at or below it, but not past `target`.
    ///
    /// Follows decotengu's `_find_first_stop`.
    func ascendedToCeiling(_ diver: Diver, stoppingAt target: Double) throws(Error) -> Diver {
        var diver = diver
        while true {
            let tolerated = try toleratedAmbientPressure(of: diver.compartments, gradientFactor: gradientFactors.low)
            let limit = Swift.max(target, grid.roundedUp(depth(at: tolerated)))
            guard diver.depth > limit else { return diver }
            diver = try moved(diver, to: limit)
        }
    }

    /// Returns the diver after switching to `gas` at its exact switch depth and
    /// ascending to the stop at or above it, or `nil` if the low-gradient-factor
    /// ceiling would then be deeper than the diver.
    ///
    /// If `next` switches before that stop, the diver instead ascends only to its
    /// switch depth, and the check is left to that switch.
    ///
    /// Follows decotengu's `_ascent_switch_gas` and its check in `_free_staged_ascent`.
    func switched(_ diver: Diver, to gas: Gas, before next: Gas?) throws(Error) -> Diver? {
        let switchDepth = gas.switchDepth.forceUnwrap("Only switch gases are switched to.")
        var switched = try moved(diver, to: Swift.min(diver.depth, switchDepth))
        switched.gas = gas
        let stop = grid.roundedDown(switchDepth)
        if let nextDepth = next?.switchDepth, nextDepth > stop {
            return try moved(switched, to: Swift.min(switched.depth, nextDepth))
        }
        switched = try moved(switched, to: Swift.min(switched.depth, stop))
        let tolerated = try toleratedAmbientPressure(of: switched.compartments, gradientFactor: gradientFactors.low)
        return tolerated <= pressure(at: switched.depth) ? switched : nil
    }

    /// Returns the diver at the surface after every stop from the current depth up.
    ///
    /// Follows decotengu's `_deco_staged_ascent`, `_deco_stops` and `_deco_stop`,
    /// except that stop lengths are found minute by minute.
    func decompressed(from diver: Diver, gases: [Gas]) throws(Error) -> Diver {
        let firstStop = diver.depth
        var diver = diver
        var stopTime = Double.zero
        while diver.depth > 0 {
            let next = grid.stop(above: diver.depth)
            let gradientFactor = gradientFactors.gradientFactor(at: next, firstStop: firstStop)
            diver.gas = gas(at: diver.depth, from: gases)
            var minutes = Double.zero
            var compartments = diver.compartments
            repeat {
                minutes += 1
                guard stopTime + minutes <= Self.maximumStopTime else {
                    throw .range(.upperBound(stopTime + minutes, Self.maximumStopTime), callSite)
                }
                compartments = try loaded(
                    diver.compartments,
                    from: diver.depth,
                    to: diver.depth,
                    for: minutes,
                    breathing: diver.gas)
            } while try toleratedAmbientPressure(of: compartments, gradientFactor: gradientFactor) > pressure(at: next)
            stopTime += minutes
            diver.compartments = compartments
            diver.append(.init(unchecked: .init(diver.depth), end: .init(diver.depth), duration: .init(minutes), blend: diver.gas.blend))
            diver = try moved(diver, to: next)
        }
        return diver
    }

    /// Returns the gas for a stop: the one whose switch depth, rounded to the stop
    /// at or above it, is the shallowest at or below the stop.
    ///
    /// Follows decotengu's `_deco_ascent_stages`.
    func gas(at stop: Double, from gases: [Gas]) -> Gas {
        func key(_ gas: Gas) -> (Double, Double) {
            gas.switchDepth.map { (grid.roundedDown($0), $0) } ?? (.infinity, .infinity)
        }
        return gases
            .filter { key($0).0 >= stop }
            .min { key($0) < key($1) }
            .forceUnwrap("The starting gas is always available.")
    }
}

extension Buhlmann.Planner {
    /// Returns the diver after a constant-rate move to `depth`, breathing the current gas.
    func moved(_ diver: Diver, to depth: Double) throws(Error) -> Diver {
        guard depth != diver.depth else { return diver }
        let duration = abs(diver.depth - depth) / rate
        var moved = diver
        moved.compartments = try loaded(diver.compartments, from: diver.depth, to: depth, for: duration, breathing: diver.gas)
        moved.append(.init(unchecked: .init(diver.depth), end: .init(depth), duration: .init(duration), blend: diver.gas.blend))
        moved.depth = depth
        return moved
    }

    /// Returns the compartments after a segment from `start` to `end`.
    func loaded(
        _ compartments: [[Buhlmann.Table.MatchedGas]],
        from start: Double,
        to end: Double,
        for duration: Double,
        breathing gas: Gas) throws(Error) -> [[Buhlmann.Table.MatchedGas]] {
            let breathed = try Tissue.breathedPressures(
                from: .init(start),
                to: .init(end),
                waterVapor: waterVapor,
                increase: increase,
                callSite)
            return try compartments.map { (compartment: [Buhlmann.Table.MatchedGas]) throws(Error) in
                try compartment.map { (matched: Buhlmann.Table.MatchedGas) throws(Error) in
                    .init(
                        gas: matched.gas,
                        entry: try matched.entry.loaded(
                            for: duration,
                            fraction: gas.fractions[matched.gas] ?? .zero,
                            breathed: breathed,
                            using: model,
                            callSite),
                        limit: matched.limit)
                }
            }
        }

    /// Returns the highest ambient pressure any compartment requires, in atmospheres.
    func toleratedAmbientPressure(
        of compartments: [[Buhlmann.Table.MatchedGas]],
        gradientFactor: GradientFactor) throws(Error) -> Double {
            try Buhlmann.Table.maximumToleratedAmbientPressure(of: compartments, gradientFactor: gradientFactor, callSite)
        }

    /// Returns the ambient pressure at `depth`, in atmospheres, with the surface at one atmosphere.
    func pressure(at depth: Double) -> Double {
        Surface.ambientPressure(atDepth: depth, increase: increase)
    }

    /// Returns the depth at an ambient pressure, negative above the surface.
    func depth(at pressure: Double) -> Double {
        Surface.depth(atAmbientPressure: pressure, increase: increase)
    }
}
