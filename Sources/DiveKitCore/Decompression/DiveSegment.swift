import Foundation

/// A constant-rate depth change, or a stop, breathing one blend.
///
/// Public construction that validates the depths and duration lives in the
/// top-level `DiveKit` module.
///
/// - Warning: DiveKit's decompression calculations have not been validated for
///   planning real dives.
///
/// - Since: 1.0.0
public struct DiveSegment: Sendable, Equatable {
    /// The depth at the start of the segment, in the configured units.
    ///
    /// - Since: 1.0.0
    public let start: Depth

    /// The depth at the end of the segment, in the configured units.
    ///
    /// - Since: 1.0.0
    public let end: Depth

    /// The segment duration in minutes.
    ///
    /// - Since: 1.0.0
    public let duration: Minutes

    /// The breathing gas.
    ///
    /// - Since: 1.0.0
    public let blend: Blend<Blended>

    /// Creates a segment without validation.
    ///
    /// - Parameters:
    ///   - start: The depth at the start of the segment.
    ///   - end: The depth at the end of the segment.
    ///   - duration: The segment duration in minutes.
    ///   - blend: The breathing gas.
    /// - Warning: This package initializer does not validate that the depths
    ///   and duration are finite and nonnegative.
    /// - Since: 1.0.0
    package init(unchecked start: Depth, end: Depth, duration: Minutes, blend: Blend<Blended>) {
        self.start = start
        self.end = end
        self.duration = duration
        self.blend = blend
    }
}
