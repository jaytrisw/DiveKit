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
            var pressures: [AnyGas: (from: Double, to: Double)] = [:]
            repeat (each inspired).record(into: &pressures)
            return try duration
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .value
                .map { (duration: Double) throws(Error) in
                    guard duration > 0 else { return self }
                    return Self(Dictionary(uniqueKeysWithValues: try storage.map { (gas, entry) throws(Error) in
                        (gas, try entry.loaded(for: duration, inspired: pressures[gas] ?? (.zero, .zero), using: model, callSite))
                    }))
                }
                .map { (compartment: Self) in
                    let untracked = pressures.keys.filter { storage[$0] == nil }.compactMap(\.gas)
                    return untracked.isEmpty ? .tracked(compartment) : .untracked(compartment, gases: untracked)
                }
        }
}

extension Tissue.Compartment.Entry {
    /// Returns this entry after a segment, validating the model's tension.
    func loaded(
        for duration: Double,
        inspired: (from: Double, to: Double),
        using model: Tissue.Loading,
        _ callSite: CallSite) throws(Error) -> Self {
            try model
                .load(tension, inspired, halfTime.value, duration)
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greaterThanOrEqual(to: .zero)) { .negative(.partialPressure($0), callSite) }
                .map { .init(halfTime: halfTime, tension: $0) }
        }
}

extension Tissue.Inspired {
    /// Records this gas's start and end pressures, skipping metabolic gases.
    func record(into pressures: inout [AnyGas: (from: Double, to: Double)]) {
        guard gas.metabolism == .inert else { return }
        pressures[.init(gas)] = (start.value, end.value)
    }
}
