import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann {
    /// How a diver ascends: the ascent rate and where decompression stops can be.
    ///
    /// Stops can be at ``lastStop`` and every ``stopInterval`` below it. All
    /// values are in the configured units, so an ascent for metric depths is
    /// not valid for imperial ones.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Ascent: Sendable, Hashable {
        /// The ascent rate, in the configured depth units per minute.
        ///
        /// - Since: 1.0.0
        public let rate: Rate<Depth>

        /// The depth between decompression stops, in the configured units.
        ///
        /// - Since: 1.0.0
        public let stopInterval: Depth

        /// The shallowest decompression stop, in the configured units.
        ///
        /// - Since: 1.0.0
        public let lastStop: Depth

        /// Creates an ascent, validating each value.
        ///
        /// - Parameters:
        ///   - rate: The ascent rate, in the configured depth units per minute.
        ///   - stopInterval: The depth between decompression stops.
        ///   - lastStop: The shallowest decompression stop.
        /// - Throws: `Error.range` if any value is not finite or is not greater than `0`.
        ///
        /// ```swift
        /// let ascent = try Buhlmann.Ascent(rate: .init(9), stopInterval: .init(3), lastStop: .init(3))
        /// ```
        ///
        /// - Since: 1.0.0
        public init(rate: Rate<Depth>, stopInterval: Depth, lastStop: Depth) throws(Error) {
            let callSite: CallSite = .from(Self.self)
            self.rate = try rate
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greater(than: .zero)) { .range(.lowerBound($0.value, 0), callSite) }
            self.stopInterval = try stopInterval
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greater(than: .zero)) { .range(.lowerBound($0.value, 0), callSite) }
            self.lastStop = try lastStop
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greater(than: .zero)) { .range(.lowerBound($0.value, 0), callSite) }
        }
    }
}
