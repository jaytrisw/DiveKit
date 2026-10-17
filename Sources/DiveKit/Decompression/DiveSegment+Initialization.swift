import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension DiveSegment {
    /// Creates a segment, validating the depths and duration.
    ///
    /// Depths are in the configured units of the calculation the segment is
    /// used in. A stop has equal start and end depths.
    ///
    /// - Parameters:
    ///   - start: The depth at the start of the segment.
    ///   - end: The depth at the end of the segment.
    ///   - duration: The segment duration in minutes.
    ///   - blend: The breathing gas.
    /// - Throws: `Error.negative` if either depth or `duration` is negative, or
    ///   `Error.range` if any of them is not finite.
    ///
    /// ```swift
    /// let descent = try DiveSegment(start: .init(0), end: .init(30), duration: .init(1.5), blend: .air)
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    init(start: Depth, end: Depth, duration: Minutes, blend: Blend<Blended>) throws(Error) {
        let callSite: CallSite = .from(Self.self)
        self.init(
            unchecked: try start
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) }),
            end: try end
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) }),
            duration: try duration
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) }),
            blend: blend)
    }
}
