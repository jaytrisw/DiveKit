import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

public extension GasCalculator {
    /// Calculates the equivalent narcotic depth (END).
    ///
    /// Each gas contributes its fraction weighted by its narcotic potency,
    /// relative to nitrogen. The result is the depth at which `Blend.air`, under
    /// the same potencies, is equally narcotic, so the END of air always equals
    /// the actual depth.
    ///
    /// Oxygen is not narcotic by default. To treat it as narcotic, as many
    /// agencies do, pass `.narcotic(.oxygen)`. Treatments apply to this
    /// calculation only; if a gas is treated more than once, the last treatment
    /// wins.
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The gas mixture.
    ///   - overrides: Narcotic potencies that replace each gas's own potency.
    /// - Returns: A calculation containing the equivalent narcotic depth.
    /// - Throws: `Error.negative` if `depth` is negative, or `Error.range` if
    ///   a potency is negative or not finite, if air is not narcotic under the
    ///   given treatments, or if the result is not finite.
    ///
    /// ```swift
    /// let end = try calculator.equivalentNarcoticDepth(
    ///     for: 60,
    ///     with: .trimix(oxygen: 0.18, helium: 0.45),
    ///     treating: .narcotic(.oxygen)
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    @_spi(Experimental)
    func equivalentNarcoticDepth(
        for depth: Depth,
        with blend: Blend<Blended>,
        treating overrides: NarcoticTreatment...) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try equivalentNarcoticDepth(for: depth, with: blend, treating: overrides, .from(self))
        }

    /// Calculates the equivalent narcotic depth (END) for an unblended gas mixture.
    ///
    /// This method converts an unblended mixture into a blended state and then
    /// computes the equivalent narcotic depth.
    ///
    /// - Parameters:
    ///   - depth: The actual depth.
    ///   - blend: The unblended gas mixture.
    ///   - overrides: Narcotic potencies that replace each gas's own potency.
    /// - Returns: A calculation containing the equivalent narcotic depth.
    /// - Throws: `Error.blend` if the blend cannot be normalized,
    ///   `Error.negative` if `depth` is negative, or `Error.range` if a potency
    ///   is negative or not finite, if air is not narcotic under the given
    ///   treatments, or if the result is not finite.
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
        with blend: Blend<Unblended>,
        treating overrides: NarcoticTreatment...) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            let callSite: CallSite = .from(self)
            return try blend.blend(callSite)
                .map { (blended: Blend<Blended>) throws(DiveKit.Error) in
                    try equivalentNarcoticDepth(for: depth, with: blended, treating: overrides, callSite)
                }
        }
}

private extension GasCalculator {
    func equivalentNarcoticDepth(
        for depth: Depth,
        with blend: Blend<Blended>,
        treating overrides: [NarcoticTreatment],
        _ callSite: CallSite) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { $0.value + configuration.water.pressure(configuration.units).increase.value }
                .with { () throws(DiveKit.Error) in
                    var potencies: [AnyGas: NarcoticPotency] = [:]
                    for override in overrides {
                        potencies[override.gas] = try validated(override.potency, callSite)
                    }
                    let air = try narcoticLoad(of: .air, potencies, callSite)
                        .validate(using: .greater(than: 0)) { .range(.lowerBound($0, 0), callSite) }
                    return try narcoticLoad(of: blend, potencies, callSite) / air
                }
                .map { $0.first * $0.second }
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
                .map { $0 - configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: \.depth, from: configuration) }
        }

    func narcoticLoad(
        of blend: Blend<Blended>,
        _ potencies: [AnyGas: NarcoticPotency],
        _ callSite: CallSite) throws(DiveKit.Error) -> Double {
            var load: Double = .zero
            for gas in blend.components() {
                let potency = if let override = potencies[.init(gas)] {
                    override
                } else {
                    try validated(gas.narcoticPotency, callSite)
                }
                load += blend.fractionalPressure(of: gas) * potency.value
            }
            return load
        }

    func validated(_ potency: NarcoticPotency, _ callSite: CallSite) throws(DiveKit.Error) -> NarcoticPotency {
        switch potency {
            case .none:
                return potency
            case let .relative(value):
                try value
                    .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
                    .validate(using: .greaterThanOrEqual(to: 0)) { .range(.lowerBound($0, 0), callSite) }
                return potency
        }
    }
}
