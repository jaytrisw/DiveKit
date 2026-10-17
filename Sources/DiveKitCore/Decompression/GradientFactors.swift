import Foundation

/// A pair of gradient factors for planning an ascent.
///
/// ``low`` applies at the first decompression stop and ``high`` at the
/// surface, with the gradient factor changing linearly with depth between
/// them. A lower ``low`` gives a first stop at the same depth or deeper; a
/// lower ``high`` gives the same or longer shallow stops. Public construction
/// that validates the pair lives in the top-level `DiveKit` module.
///
/// - Warning: DiveKit's decompression calculations have not been validated for
///   planning real dives.
///
/// - Since: 1.0.0
public struct GradientFactors: Sendable, Hashable {
    /// The gradient factor at the first decompression stop.
    ///
    /// - Since: 1.0.0
    public let low: GradientFactor

    /// The gradient factor at the surface.
    ///
    /// - Since: 1.0.0
    public let high: GradientFactor

    /// Creates a pair of gradient factors without validation.
    ///
    /// - Parameters:
    ///   - low: The gradient factor at the first decompression stop.
    ///   - high: The gradient factor at the surface.
    /// - Warning: This package initializer does not validate that `low` is at
    ///   most `high`.
    /// - Since: 1.0.0
    package init(unchecked low: GradientFactor, high: GradientFactor) {
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
