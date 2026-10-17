import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann {
    /// A pair of gradient factors for planning an ascent.
    ///
    /// ``low`` applies at the first decompression stop and ``high`` at the
    /// surface, with the gradient factor changing linearly with depth between
    /// them. A lower ``low`` gives a first stop at the same depth or deeper; a
    /// lower ``high`` gives the same or longer shallow stops.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct GradientFactors: Sendable, Hashable {
        /// The gradient factor at the first decompression stop.
        ///
        /// - Since: 1.0.0
        public let low: GradientFactor

        /// The gradient factor at the surface.
        ///
        /// - Since: 1.0.0
        public let high: GradientFactor

        /// Creates a pair of gradient factors.
        ///
        /// - Parameters:
        ///   - low: The gradient factor at the first decompression stop.
        ///   - high: The gradient factor at the surface.
        /// - Throws: `Error.range` if `low` is greater than `high`.
        ///
        /// ```swift
        /// let gradientFactors = try Buhlmann.GradientFactors(low: try .init(0.3), high: try .init(0.85))
        /// ```
        ///
        /// - Since: 1.0.0
        public init(low: GradientFactor, high: GradientFactor) throws(Error) {
            let callSite: CallSite = .from(Self.self)
            _ = try low.value
                .validate(using: .lessThanOrEqual(to: high.value)) { .range(.upperBound($0, high.value), callSite) }
            self.low = low
            self.high = high
        }

        private init(unchecked low: GradientFactor, high: GradientFactor) {
            self.low = low
            self.high = high
        }

        /// The raw Bühlmann limit at every depth, with both gradient factors `1`.
        ///
        /// - Since: 1.0.0
        public static var full: Self {
            .init(unchecked: .full, high: .full)
        }
    }
}

extension Buhlmann.GradientFactors {
    /// Returns the gradient factor at `depth`, interpolated linearly from ``low``
    /// at `firstStop` to ``high`` at the surface.
    func gradientFactor(at depth: Double, firstStop: Double) -> Buhlmann.GradientFactor {
        guard firstStop > 0 else { return high }
        let value = high.value - (high.value - low.value) * Swift.min(Swift.max(depth / firstStop, .zero), .one)
        // Clamped so rounding can't leave the range of two valid gradient factors.
        return .init(unchecked: Swift.min(Swift.max(value, low.value), high.value))
    }
}
