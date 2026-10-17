import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension GradientFactors {
    /// Creates a pair of gradient factors.
    ///
    /// - Parameters:
    ///   - low: The gradient factor at the first decompression stop.
    ///   - high: The gradient factor at the surface.
    /// - Throws: `Error.range` if `low` is greater than `high`.
    ///
    /// ```swift
    /// let gradientFactors = try GradientFactors(low: try .init(0.3), high: try .init(0.85))
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    init(low: GradientFactor, high: GradientFactor) throws(Error) {
        let callSite: CallSite = .from(Self.self)
        _ = try low.value
            .validate(using: .lessThanOrEqual(to: high.value)) { .range(.upperBound($0, high.value), callSite) }
        self.init(unchecked: low, high: high)
    }
}

extension GradientFactors {
    /// Returns the gradient factor at `depth`, interpolated linearly from ``low``
    /// at `firstStop` to ``high`` at the surface.
    func gradientFactor(at depth: Double, firstStop: Double) -> GradientFactor {
        guard firstStop > 0 else { return high }
        let value = high.value - (high.value - low.value) * Swift.min(Swift.max(depth / firstStop, .zero), .one)
        // Clamped so rounding can't leave the range of two valid gradient factors.
        return .init(unchecked: Swift.min(Swift.max(value, low.value), high.value))
    }
}
