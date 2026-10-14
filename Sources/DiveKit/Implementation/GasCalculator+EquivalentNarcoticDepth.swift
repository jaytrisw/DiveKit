import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

public extension GasCalculator {
    /// Calculates the equivalent narcotic depth (END).
    ///
    /// This model treats helium as the only non-narcotic component. It treats all
    /// other components, including oxygen, as equally narcotic and assumes one
    /// atmosphere of pressure at the surface.
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The gas mixture.
    /// - Returns: A calculation containing the equivalent narcotic depth.
    /// - Throws: `Error.negative` if `depth` is negative.
    ///
    /// ```swift
    /// let end = try calculator.equivalentNarcoticDepth(
    ///     for: 60,
    ///     with: .trimix(oxygen: 0.18, helium: 0.45)
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    @_spi(Experimental)
    func equivalentNarcoticDepth(
        for depth: Depth,
        with blend: Blend<Blended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
                .with { () throws(DiveKit.Error) in
                    try 1 - blend.fractionalPressure(of: .helium).value
                }
                .map { $0.first * $0.second }
                .map { $0 - configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: \.depth, from: configuration) }
        }

    /// Calculates the equivalent narcotic depth (END) for an unblended gas mixture.
    ///
    /// This method converts an unblended mixture into a blended state and then
    /// computes the equivalent narcotic depth based on the helium content.
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The unblended gas mixture.
    /// - Returns: A calculation containing the equivalent narcotic depth.
    /// - Throws: `Error.blend` if the blend cannot be normalized, or
    ///   `Error.negative` if `depth` is negative.
    ///
    /// ```swift
    /// let end = try calculator.equivalentNarcoticDepth(
    ///     for: 60,
    ///     with: blend
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    @_spi(Experimental)
    func equivalentNarcoticDepth(
        for depth: Depth,
        with blend: Blend<Unblended>) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try blend.blend(.from(self))
                .map { (blended: Blend<Blended>) throws(DiveKit.Error) in
                    try equivalentNarcoticDepth(for: depth, with: blended)
                }
        }
}
