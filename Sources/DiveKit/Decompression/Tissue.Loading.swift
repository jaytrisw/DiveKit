import Foundation

@_spi(Experimental)
public extension Tissue {
    /// An equation that updates one inert-gas tension in a tissue compartment.
    ///
    /// `Tissue.Loading` is a protocol witness: create one from a closure to supply
    /// a custom loading equation, or use a built-in model such as ``schreiner`` or
    /// ``haldane``. The closure is applied separately to each inert gas with that
    /// gas's half-time.
    ///
    /// `Tissue.Compartment` validates every input before calling ``load``: all
    /// values are finite, pressures are nonnegative, and the duration and
    /// half-time are greater than zero. It also validates the returned tension and
    /// throws `Error.negative` or `Error.range` if it is negative or not finite.
    ///
    /// The built-in models are accurate to within rounding of their largest
    /// input. A change much smaller than that, such as the uptake over a
    /// vanishingly short segment, can lose relative precision or round away.
    ///
    /// A witness updates one compartment at a time, so models whose compartments
    /// exchange gas with each other cannot be expressed.
    ///
    /// ```swift
    /// let instantaneous = Tissue.Loading { _, inspired, _, _ in
    ///     inspired.to
    /// }
    /// ```
    ///
    /// - Since: 1.0.0
    struct Loading: Sendable {
        /// Returns the tension after a segment.
        ///
        /// - Parameters:
        ///   - tension: The tension at the start of the segment, in atmospheres.
        ///   - inspired: The inspired partial pressures at the start and end of the
        ///     segment, in atmospheres. They are equal for a constant-pressure segment.
        ///   - halfTime: The gas half-time, in minutes.
        ///   - duration: The segment duration, in minutes.
        /// - Returns: The tension at the end of the segment, in atmospheres.
        /// - Since: 1.0.0
        public var load: @Sendable (
            _ tension: Double,
            _ inspired: (from: Double, to: Double),
            _ halfTime: Double,
            _ duration: Double) -> Double

        /// Creates a loading model from a closure.
        ///
        /// - Parameter load: Returns the tension after a segment. See ``load``.
        /// - Since: 1.0.0
        public init(
            load: @escaping @Sendable (
                _ tension: Double,
                _ inspired: (from: Double, to: Double),
                _ halfTime: Double,
                _ duration: Double) -> Double) {
                    self.load = load
                }
    }
}

@_spi(Experimental)
public extension Tissue.Loading {
    /// The Schreiner equation, exact for inspired pressures that change linearly.
    ///
    /// At constant inspired pressure this gives the same result as ``haldane``.
    ///
    /// - Since: 1.0.0
    static var schreiner: Self {
        .init { tension, inspired, halfTime, duration in
            // Written as a convex combination of its three inputs so no intermediate
            // exceeds the largest of them, and long half-times avoid the cancellation
            // between 1/k terms in the textbook form.
            let exponent = log(2.0) * (duration / halfTime)
            let remaining = exp(-exponent)
            let lag = exponent > 0 ? -expm1(-exponent) / exponent : 1
            return (remaining * tension + (lag - remaining) * inspired.from + (1 - lag) * inspired.to)
                .clamped(toRangeOf: tension, inspired.from, inspired.to)
        }
    }

    /// The Haldane equation, exact for constant inspired pressure.
    ///
    /// When the inspired pressure changes during a segment, this uses the mean of
    /// the start and end pressures. Use it to match planners and dive computers
    /// that step through a dive at constant pressure.
    ///
    /// - Since: 1.0.0
    static var haldane: Self {
        .init { tension, inspired, halfTime, duration in
            let remaining = exp(-log(2.0) * (duration / halfTime))
            let inspiredMean = inspired.from / 2 + inspired.to / 2
            return (remaining * tension + (1 - remaining) * inspiredMean)
                .clamped(toRangeOf: tension, inspiredMean)
        }
    }
}

private extension Double {
    /// Clamps a weighted average to the range of the values it averages.
    ///
    /// Rounding each weighted term separately can push the sum just past its
    /// largest input, which overflows when that input is near the largest finite
    /// `Double`.
    func clamped(toRangeOf first: Double, _ rest: Double...) -> Double {
        let lower = rest.reduce(first, Swift.min)
        let upper = rest.reduce(first, Swift.max)
        return Swift.min(Swift.max(self, lower), upper)
    }
}
