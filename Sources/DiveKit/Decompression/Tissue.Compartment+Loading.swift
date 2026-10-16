import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue.Compartment {
    /// Returns the loading after a segment at constant inspired pressures.
    ///
    /// The pressures must already account for the caller's breathing model.
    ///
    /// - Parameters:
    ///   - duration: The segment duration in minutes.
    ///   - inspiredNitrogen: The inspired nitrogen pressure in atmospheres.
    ///   - inspiredHelium: The inspired helium pressure in atmospheres.
    ///   - model: The loading equation. Defaults to ``Tissue/Loading/schreiner``.
    /// - Returns: A compartment with the same half-times and updated tensions.
    /// - Throws: `Error.negative` if the duration or a pressure is negative,
    ///   or `Error.range` if any of them is not finite. Also throws
    ///   `Error.negative` or `Error.range` if `model` returns a negative or
    ///   non-finite tension.
    ///
    /// ```swift
    /// let loaded = try compartment.loaded(
    ///     for: 20,
    ///     inspiredNitrogen: 2.45,
    ///     inspiredHelium: 0)
    /// ```
    ///
    /// - Since: 1.1.0
    func loaded(
        for duration: Minutes,
        inspiredNitrogen: PartialPressure<Nitrogen>,
        inspiredHelium: PartialPressure<Helium>,
        using model: Tissue.Loading = .schreiner) throws(Error) -> Self {
            try loaded(
                for: duration,
                nitrogen: (inspiredNitrogen, inspiredNitrogen),
                helium: (inspiredHelium, inspiredHelium),
                model,
                .from(Self.self))
        }

    /// Returns the loading after a segment where inspired pressures change linearly.
    ///
    /// Use the inspired partial pressures at the start and end of a constant-rate
    /// ascent or descent. The gas mixture must remain unchanged during the segment.
    ///
    /// - Parameters:
    ///   - duration: The segment duration in minutes.
    ///   - nitrogenFrom: The inspired nitrogen pressure at the start of the segment.
    ///   - nitrogenTo: The inspired nitrogen pressure at the end of the segment.
    ///   - heliumFrom: The inspired helium pressure at the start of the segment.
    ///   - heliumTo: The inspired helium pressure at the end of the segment.
    ///   - model: The loading equation. Defaults to ``Tissue/Loading/schreiner``.
    /// - Returns: A compartment with the same half-times and updated tensions.
    /// - Throws: `Error.negative` if the duration or a pressure is negative,
    ///   or `Error.range` if any of them is not finite. Also throws
    ///   `Error.negative` or `Error.range` if `model` returns a negative or
    ///   non-finite tension.
    ///
    /// ```swift
    /// let descended = try compartment.loaded(
    ///     for: 2,
    ///     nitrogenFrom: 0.74,
    ///     nitrogenTo: 2.45,
    ///     heliumFrom: 0,
    ///     heliumTo: 0)
    /// ```
    ///
    /// - Since: 1.1.0
    func loaded(
        for duration: Minutes,
        nitrogenFrom: PartialPressure<Nitrogen>,
        nitrogenTo: PartialPressure<Nitrogen>,
        heliumFrom: PartialPressure<Helium>,
        heliumTo: PartialPressure<Helium>,
        using model: Tissue.Loading = .schreiner) throws(Error) -> Self {
            try loaded(
                for: duration,
                nitrogen: (nitrogenFrom, nitrogenTo),
                helium: (heliumFrom, heliumTo),
                model,
                .from(Self.self))
        }
}

private extension Tissue.Compartment {
    func loaded(
        for duration: Minutes,
        nitrogen inspiredNitrogen: (from: PartialPressure<Nitrogen>, to: PartialPressure<Nitrogen>),
        helium inspiredHelium: (from: PartialPressure<Helium>, to: PartialPressure<Helium>),
        _ model: Tissue.Loading,
        _ callSite: CallSite) throws(Error) -> Self {
            let duration = try duration
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .value
            let nitrogenFrom = try inspiredNitrogen.from
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .value
            let nitrogenTo = try inspiredNitrogen.to
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .value
            let heliumFrom = try inspiredHelium.from
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .value
            let heliumTo = try inspiredHelium.to
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .value
            guard duration > 0 else { return self }

            let nextNitrogen = PartialPressure<Nitrogen>(model.load(
                nitrogen.value,
                (nitrogenFrom, nitrogenTo),
                halfTimes.nitrogen.value,
                duration))
            let nextHelium = PartialPressure<Helium>(model.load(
                helium.value,
                (heliumFrom, heliumTo),
                halfTimes.helium.value,
                duration))
            return .init(
                halfTimes,
                try nextNitrogen
                    .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                    .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) },
                try nextHelium
                    .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                    .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) })
        }
}
