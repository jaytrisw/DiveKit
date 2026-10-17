import Foundation

/// An ascent from depth to the surface, as a sequence of segments.
///
/// A decompression stop is a segment whose start and end depths are equal. A
/// gas switch is where consecutive segments breathe different blends. The
/// segments can be passed to ``DecompressionCalculating/loaded(_:through:)``
/// to load tissues through the ascent.
///
/// - Warning: DiveKit's decompression calculations have not been validated for
///   planning real dives.
///
/// - Since: 1.0.0
public struct DecompressionSchedule: ResultRepresentable, Equatable {
    /// The segments in order, starting at depth and ending at the surface.
    ///
    /// - Since: 1.0.0
    public let segments: [DiveSegment]

    /// Creates a schedule.
    ///
    /// - Parameter segments: The segments in order.
    /// - Since: 1.0.0
    package init(segments: [DiveSegment]) {
        self.segments = segments
    }
}
