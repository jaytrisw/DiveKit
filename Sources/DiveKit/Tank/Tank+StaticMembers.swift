import Foundation
import DiveKitCore

public extension Tank {
    /// Creates a tank defined by cubic feet capacity and rated pressure.
    ///
    /// - Parameters:
    ///   - volume: The rated surface gas capacity of the tank, in cubic feet.
    ///   - ratedPressure: The rated pressure of the tank, in PSI.
    ///   - blend: The gas blend contained in the tank.
    /// - Returns: A `Tank` configured with cubic feet units.
    ///
    /// ```swift
    /// let tank = Tank.cubicFeet(
    ///     80,
    ///     ratedPressure: 3000,
    ///     with: blend)
    /// ```
    ///
    /// - Note: This method assumes the provided `blend` is already validated
    ///   and in a `Blended` state.
    /// - Since: 1.0.0
    static func cubicFeet(
        _ volume: Volume,
        ratedPressure: Pressure,
        with blend: Blend<Blended>) -> Self {
            .init(
                blend: blend,
                size: .init(
                    volume: volume,
                    ratedPressure: ratedPressure,
                    unit: .cubicFeet))
        }
}
