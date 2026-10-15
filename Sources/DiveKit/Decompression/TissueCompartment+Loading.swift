import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension TissueCompartment {
    /// Returns the loading after a segment at constant inspired pressures.
    ///
    /// The pressures must already account for the caller's breathing model.
    ///
    /// - Parameters:
    ///   - duration: The segment duration in minutes.
    ///   - inspiredNitrogen: The inspired nitrogen pressure in atmospheres.
    ///   - inspiredHelium: The inspired helium pressure in atmospheres.
    /// - Returns: A compartment with the same half-times and updated tensions.
    /// - Throws: `Error.negative` if the duration or a pressure is negative,
    ///   or `Error.range` if any of them, or an updated tension, is not finite.
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
        inspiredHelium: PartialPressure<Helium>) throws(Error) -> Self {
            try loaded(
                for: duration,
                nitrogen: (inspiredNitrogen, inspiredNitrogen),
                helium: (inspiredHelium, inspiredHelium),
                CallSite(object: .init(describing: Self.self), function: #function))
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
    /// - Returns: A compartment with the same half-times and updated tensions.
    /// - Throws: `Error.negative` if the duration or a pressure is negative,
    ///   or `Error.range` if any of them, or an updated tension, is not finite.
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
        heliumTo: PartialPressure<Helium>) throws(Error) -> Self {
            try loaded(
                for: duration,
                nitrogen: (nitrogenFrom, nitrogenTo),
                helium: (heliumFrom, heliumTo),
                CallSite(object: .init(describing: Self.self), function: #function))
        }
}

private extension TissueCompartment {
    func loaded(
        for duration: Minutes,
        nitrogen inspiredNitrogen: (from: PartialPressure<Nitrogen>, to: PartialPressure<Nitrogen>),
        helium inspiredHelium: (from: PartialPressure<Helium>, to: PartialPressure<Helium>),
        _ callSite: CallSite) throws(Error) -> Self {
            let duration = try Self.validated(duration: duration, callSite).value
            let nitrogenFrom = try Self.validated(inspiredNitrogen.from, callSite).value
            let nitrogenTo = try Self.validated(inspiredNitrogen.to, callSite).value
            let heliumFrom = try Self.validated(inspiredHelium.from, callSite).value
            let heliumTo = try Self.validated(inspiredHelium.to, callSite).value
            guard duration > 0 else { return self }

            let nextNitrogen = PartialPressure<Nitrogen>(Self.loading(
                from: nitrogen.value,
                inspiredFrom: nitrogenFrom,
                inspiredTo: nitrogenTo,
                halfTime: halfTimes.nitrogen.value,
                duration: duration))
            let nextHelium = PartialPressure<Helium>(Self.loading(
                from: helium.value,
                inspiredFrom: heliumFrom,
                inspiredTo: heliumTo,
                halfTime: halfTimes.helium.value,
                duration: duration))
            return .init(
                halfTimes,
                try Self.validated(nextNitrogen, callSite),
                try Self.validated(nextHelium, callSite))
        }

    static func loading(
        from tissue: Double,
        inspiredFrom start: Double,
        inspiredTo end: Double,
        halfTime: Double,
        duration: Double) -> Double {
            // Schreiner equation written as a convex combination of its three inputs so
            // no intermediate exceeds the largest of them, and long half-times avoid the
            // cancellation between 1/k terms in the textbook form. Rounding can still
            // push a result built from values near Double.greatestFiniteMagnitude past
            // it, which the caller rejects.
            let exponent = log(2.0) / halfTime * duration
            let remaining = exp(-exponent)
            let lag = exponent > 0 ? -expm1(-exponent) / exponent : 1
            return remaining * tissue + (lag - remaining) * start + (1 - lag) * end
        }
}
