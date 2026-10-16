import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue.Compartment {
    /// Returns the loading after a segment.
    ///
    /// A tracked gas that is not listed is treated as having an inspired
    /// pressure of `0`. A listed inert gas that this compartment does not track
    /// is ignored and reported in the result. Metabolic gases, such as oxygen,
    /// are ignored without being reported, so a full breathing mix can be
    /// passed. If a gas is listed more than once, the last pressure is used.
    ///
    /// - Parameters:
    ///   - duration: The segment duration in minutes.
    ///   - inspired: The inspired partial pressure of each gas over the segment.
    ///   - model: The loading equation. Defaults to ``Tissue/Loading/schreiner``.
    /// - Returns: `.tracked` with the updated compartment, or `.untracked` with
    ///   the updated compartment and the inspired gases it does not track.
    /// - Throws: `Error.negative` if `duration` is negative, or `Error.range` if
    ///   it is not finite. Also throws `Error.negative` or `Error.range` if
    ///   `model` returns a negative or non-finite tension.
    ///
    /// ```swift
    /// switch try compartment.loaded(
    ///     for: .init(2),
    ///     inspired: try .init(of: .nitrogen, from: .init(0.74), to: .init(2.45))) {
    /// case .tracked(let loaded):
    ///     compartment = loaded
    /// case .untracked(let loaded, let gases):
    ///     compartment = loaded
    ///     print("Not modeled: \(gases)")
    /// }
    /// ```
    ///
    /// - Since: 1.0.0
    func loaded<each Gas: GasRepresentable>(
        for duration: Minutes,
        inspired: repeat Tissue.Inspired<each Gas>,
        using model: Tissue.Loading = .schreiner) throws(Error) -> Loaded {
            let callSite: CallSite = .from(Self.self)
            let duration = try duration
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .value
            var pressures: [AnyGas: (from: Double, to: Double)] = [:]
            for gas in repeat each inspired {
                guard gas.gas.metabolism == .inert else { continue }
                pressures[.init(gas.gas)] = (gas.start.value, gas.end.value)
            }

            var next = storage
            if duration > 0 {
                for (gas, entry) in storage {
                    let tension = try model
                        .load(entry.tension, pressures[gas] ?? (.zero, .zero), entry.halfTime.value, duration)
                        .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
                        .validate(using: .greaterThanOrEqual(to: .zero)) { .negative(.partialPressure($0), callSite) }
                    next[gas] = .init(halfTime: entry.halfTime, tension: tension)
                }
            }

            let compartment = Self(next)
            let untracked = pressures.keys.filter { storage[$0] == nil }.compactMap(\.gas)
            return untracked.isEmpty ? .tracked(compartment) : .untracked(compartment, gases: untracked)
        }
}
