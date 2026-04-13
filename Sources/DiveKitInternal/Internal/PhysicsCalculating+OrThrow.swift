import Foundation
import DiveKitCore

package extension PhysicsCalculating {
    /// Calculates the gauge pressure at a given depth.
    ///
    /// Gauge pressure represents the pressure increase caused by the surrounding
    /// water relative to surface pressure.
    ///
    /// - Parameters:
    ///   - depth: The depth at which to calculate gauge pressure.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the gauge pressure at `depth`.
    /// - Throws: `DiveKitCore.Error.negative` if `depth` is negative.
    ///
    /// ## Formula
    ///
    /// `gauge pressure = depth ÷ pressure increase per atmosphere`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = try calculator.gaugePressure(
    ///     at: 20,
    ///     with: configuration,
    ///     callSite
    /// )
    /// ```
    ///
    /// - Note: This result excludes surface atmospheric pressure.
    /// - Since: 1.0.0
    func gaugePressure(
        at depth: Depth,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Pressure>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { $0.value / configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: .atmospheres, configuration: configuration) }
        }

    /// Calculates the absolute pressure at a given depth in atmospheres absolute.
    ///
    /// Absolute pressure is the sum of surface atmospheric pressure and the
    /// additional pressure caused by the surrounding water at depth.
    ///
    /// - Parameters:
    ///   - depth: The depth at which to calculate absolute pressure.
    ///   - configuration: The calculation configuration.
    ///   - callSite: The location where the calculation was requested.
    /// - Returns: A calculation containing the absolute pressure at `depth`.
    /// - Throws: `DiveKitCore.Error.negative` if `depth` is negative. This
    ///   method only throws typed domain errors forwarded from `gaugePressure(at:with:_:)`.
    ///
    /// ## Formula
    ///
    /// `absolute pressure = gauge pressure + 1`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = try calculator.atmospheresAbsolute(
    ///     at: 20,
    ///     with: configuration,
    ///     callSite
    /// )
    /// ```
    ///
    /// - Note: The added `1` represents surface atmospheric pressure.
    /// - Since: 1.0.0
    func atmospheresAbsolute(
        at depth: Depth,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Pressure>> {
            try gaugePressure(at: depth, with: configuration, callSite)
                .map { .decimal($0.result.value + 1, unit: $0.result.unit, configuration: $0.configuration) }
        }
}
