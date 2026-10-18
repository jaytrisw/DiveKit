import Foundation

/// The surface pressure DiveKit assumes, and conversions between depth and
/// ambient pressure.
///
/// DiveKit fixes the surface at one atmosphere, as at sea level, and does not
/// model altitude. Conversions between depth and ambient pressure go through
/// here, so modeling altitude would change one place.
///
/// - Since: 1.0.0
package enum Surface {
    /// The surface pressure, in atmospheres.
    ///
    /// - Since: 1.0.0
    package static var pressure: Double { 1 }

    /// Returns the ambient pressure at a depth, in atmospheres.
    ///
    /// - Parameters:
    ///   - depth: The depth, in the units of `increase`.
    ///   - increase: The depth per atmosphere, already validated.
    /// - Returns: `pressure + depth / increase`.
    /// - Since: 1.0.0
    package static func ambientPressure(atDepth depth: Double, increase: Double) -> Double {
        pressure + depth / increase
    }

    /// Returns the depth at an ambient pressure, negative above the surface.
    ///
    /// - Parameters:
    ///   - ambientPressure: The ambient pressure, in atmospheres.
    ///   - increase: The depth per atmosphere, already validated.
    /// - Returns: `(ambientPressure − pressure) × increase`.
    /// - Since: 1.0.0
    package static func depth(atAmbientPressure ambientPressure: Double, increase: Double) -> Double {
        (ambientPressure - pressure) * increase
    }
}
