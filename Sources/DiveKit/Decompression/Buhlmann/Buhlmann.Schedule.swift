import Foundation
import DiveKitCore

@_spi(Experimental)
public extension Buhlmann {
    /// An ascent from depth to the surface, as a sequence of segments.
    ///
    /// A decompression stop is a segment whose start and end depths are equal. A
    /// gas switch is where consecutive segments breathe different blends. Each
    /// segment can be loaded with
    /// ``Tissue/Inspired/init(of:breathing:from:to:waterVapor:configuration:)``
    /// and ``Tissue/Compartment/loaded(for:inspired:using:)``.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Schedule: ResultRepresentable, Equatable {
        /// The segments in order, starting at depth and ending at the surface.
        ///
        /// - Since: 1.0.0
        public let segments: [Segment]
    }
}

@_spi(Experimental)
public extension Buhlmann.Schedule {
    /// A constant-rate depth change, or a stop, breathing one blend.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Segment: Sendable, Equatable {
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
    }
}
