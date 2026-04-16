import Foundation
import DiveKitCore

public extension Blend where State == Blended {
    /// A standard air gas mixture.
    ///
    /// This blend represents atmospheric air using typical fractional pressures
    /// for oxygen, nitrogen, and trace gases.
    ///
    /// - Returns: A `Blend` in the `Blended` state representing air.
    ///
    /// ```swift
    /// let air = Blend.air
    /// ```
    ///
    /// - Note:
    ///   - Oxygen: `20.9%`
    ///   - Nitrogen: `79%`
    ///   - Trace gases: `0.1%`
    /// - Since: 1.0.0
    static var air: Blend<Blended> {
        .init {
            FractionalPressure(.oxygen, fractionalPressure: 0.209)
            FractionalPressure(.nitrogen, fractionalPressure: 0.79)
            FractionalPressure(.trace, fractionalPressure: 0.001)
        }
    }

    /// Creates an enriched air (Nitrox) gas mixture.
    ///
    /// This method constructs a two-gas blend consisting of oxygen and nitrogen,
    /// where the oxygen fraction is specified and the nitrogen fraction fills
    /// the remainder.
    ///
    /// - Parameter fraction: The fractional pressure of oxygen.
    /// - Returns: A `Blend` in the `Blended` state representing enriched air.
    /// - Throws: `Error.negative` if `fraction` is negative, or
    ///   `Error.range` if `fraction` is greater than `1`.
    ///
    /// ## Formula
    ///
    /// `nitrogen fraction = 1.0 - oxygen fraction`
    ///
    /// ```swift
    /// let enrichedAir = try Blend.enrichedAir(0.32) // EAN32
    /// ```
    ///
    /// - Important: The provided `fraction` must be within `0...1`.
    /// - Since: 1.0.0
    static func enrichedAir(_ fraction: Double) throws(Error) -> Blend<Blended> {
        try .init { () throws(Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: fraction)
            try FractionalPressure(of: .nitrogen, fractionalPressure: 1.0 - fraction)
        }
    }
}
