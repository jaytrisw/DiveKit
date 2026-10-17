import Foundation

/// The fraction of Bühlmann's tolerated supersaturation a diver allows.
///
/// A gradient factor of `1` uses the raw Bühlmann limit. Smaller values keep
/// compartments further below it, which gives deeper, more conservative
/// ceilings. Public construction that validates the range lives in the
/// top-level `DiveKit` module.
///
/// - Warning: DiveKit's decompression calculations have not been validated for
///   planning real dives.
///
/// - Since: 1.0.0
public struct GradientFactor: Sendable, Hashable {
    /// The gradient factor, at least `0.01` and at most `1`.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a gradient factor without validation.
    ///
    /// - Parameter value: The gradient factor.
    /// - Warning: This package initializer does not validate that `value` is
    ///   within `0.01...1`.
    /// - Since: 1.0.0
    package init(unchecked value: Double) {
        self.value = value
    }

    /// The raw Bühlmann limit, a gradient factor of `1`.
    ///
    /// - Since: 1.0.0
    public static var full: Self {
        .init(unchecked: 1)
    }
}
