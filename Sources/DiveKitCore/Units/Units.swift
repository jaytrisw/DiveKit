import Foundation

/// A unit system used by DiveKit calculations and results.
///
/// `Units` selects the concrete units used for depth, mass, pressure, and
/// volume throughout a `Configuration`.
///
/// - Since: 1.0.0
public enum Units: Sendable {
    /// Imperial units: feet, pounds, PSI, and cubic feet.
    ///
    /// - Since: 1.0.0
    case imperial
    /// Metric units: meters, kilograms, bar, and liters.
    ///
    /// - Since: 1.0.0
    case metric
}
