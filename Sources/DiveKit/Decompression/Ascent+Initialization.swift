import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Ascent {
    /// Creates an ascent, validating each value.
    ///
    /// - Parameters:
    ///   - rate: The ascent rate, in the configured depth units per minute.
    ///   - stopInterval: The depth between decompression stops.
    ///   - lastStop: The shallowest decompression stop.
    /// - Throws: `Error.range` if any value is not finite or is not greater than `0`.
    ///
    /// ```swift
    /// let ascent = try Ascent(rate: .init(9), stopInterval: .init(3), lastStop: .init(3))
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    init(rate: Rate<Depth>, stopInterval: Depth, lastStop: Depth) throws(Error) {
        let callSite: CallSite = .from(Self.self)
        self.init(
            unchecked: try rate
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greater(than: .zero)) { .range(.lowerBound($0.value, 0), callSite) },
            stopInterval: try stopInterval
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greater(than: .zero)) { .range(.lowerBound($0.value, 0), callSite) },
            lastStop: try lastStop
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greater(than: .zero)) { .range(.lowerBound($0.value, 0), callSite) })
    }
}
