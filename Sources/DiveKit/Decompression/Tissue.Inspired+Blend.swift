import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Tissue {
    /// Bühlmann's alveolar water vapor pressure, 0.0627 bar, in atmospheres.
    ///
    /// Water vapor in the lungs displaces part of each breath, so the inspired
    /// pressure of a gas is `(P_amb − P_wv) · f`. Other models use other values,
    /// such as Schreiner's 0.0567 bar; pass your own where a parameter takes one.
    ///
    /// - Since: 1.0.0
    static var alveolarWaterVapor: Pressure {
        .init(0.0627 / 1.01325)
    }
}

@_spi(Experimental)
public extension Tissue.Inspired {
    /// Creates the constant inspired pressure of a gas breathed from a blend at a depth.
    ///
    /// The inspired pressure is `(P_amb − P_wv) · f`, where `P_amb` is the
    /// ambient pressure at `depth` with the surface at one atmosphere, `P_wv` is
    /// `waterVapor`, and `f` is the gas's fraction in `blend`. `P_amb − P_wv`
    /// is clamped at `0`. A gas the blend does not contain has an inspired
    /// pressure of `0`.
    ///
    /// - Parameters:
    ///   - gas: The inspired gas.
    ///   - blend: The breathing gas.
    ///   - depth: The depth, in the configured units.
    ///   - waterVapor: The alveolar water vapor pressure in atmospheres.
    ///     Defaults to ``Tissue/alveolarWaterVapor``.
    ///   - configuration: The units and water used to convert depth to pressure.
    /// - Throws: `Error.negative` if `depth` or `waterVapor` is negative, or
    ///   `Error.range` if either is not finite. Also throws `Error.range` if the
    ///   configured water's depth per atmosphere is not finite or not greater
    ///   than `0`, or if the ambient pressure at `depth` is not finite.
    ///
    /// ```swift
    /// let nitrogen = try Tissue.Inspired(
    ///     of: .nitrogen,
    ///     breathing: .air,
    ///     at: .init(30),
    ///     configuration: .init(units: .metric, water: .salt))
    /// ```
    ///
    /// - Since: 1.0.0
    init(
        of gas: Gas,
        breathing blend: Blend<Blended>,
        at depth: Depth,
        waterVapor: Pressure = Tissue.alveolarWaterVapor,
        configuration: Configuration) throws(Error) {
            try self.init(
                of: gas,
                breathing: blend,
                from: depth,
                to: depth,
                waterVapor: waterVapor,
                configuration: configuration,
                .from(Self.self))
        }

    /// Creates the inspired pressure of a gas breathed from a blend over a linear depth change.
    ///
    /// The start and end pressures are calculated as for
    /// ``init(of:breathing:at:waterVapor:configuration:)``.
    ///
    /// - Parameters:
    ///   - gas: The inspired gas.
    ///   - blend: The breathing gas.
    ///   - start: The depth at the start of the segment, in the configured units.
    ///   - end: The depth at the end of the segment, in the configured units.
    ///   - waterVapor: The alveolar water vapor pressure in atmospheres.
    ///     Defaults to ``Tissue/alveolarWaterVapor``.
    ///   - configuration: The units and water used to convert depth to pressure.
    /// - Throws: `Error.negative` if either depth or `waterVapor` is negative,
    ///   or `Error.range` if any of them is not finite. Also throws
    ///   `Error.range` if the configured water's depth per atmosphere is not
    ///   finite or not greater than `0`, or if the ambient pressure at either
    ///   depth is not finite.
    ///
    /// ```swift
    /// let descent = try Tissue.Inspired(
    ///     of: .nitrogen,
    ///     breathing: .air,
    ///     from: .init(0),
    ///     to: .init(30),
    ///     configuration: .init(units: .metric, water: .salt))
    /// ```
    ///
    /// - Since: 1.0.0
    init(
        of gas: Gas,
        breathing blend: Blend<Blended>,
        from start: Depth,
        to end: Depth,
        waterVapor: Pressure = Tissue.alveolarWaterVapor,
        configuration: Configuration) throws(Error) {
            try self.init(
                of: gas,
                breathing: blend,
                from: start,
                to: end,
                waterVapor: waterVapor,
                configuration: configuration,
                .from(Self.self))
        }
}

extension Tissue.Inspired {
    /// Creates the inspired pressure of a gas breathed from a blend, reporting errors at `callSite`.
    init(
        of gas: Gas,
        breathing blend: Blend<Blended>,
        from start: Depth,
        to end: Depth,
        waterVapor: Pressure,
        configuration: Configuration,
        _ callSite: CallSite) throws(Error) {
            let fraction = try blend.fractionalPressure(of: gas).value
            try self.init(
                of: gas,
                from: .init(try Tissue.breathedPressure(at: start, waterVapor: waterVapor, configuration: configuration, callSite) * fraction),
                to: .init(try Tissue.breathedPressure(at: end, waterVapor: waterVapor, configuration: configuration, callSite) * fraction))
        }
}

extension Tissue {
    /// Returns the ambient pressure at a depth less water vapor, in atmospheres, clamped at `0`.
    static func breathedPressure(
        at depth: Depth,
        waterVapor: Pressure,
        configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Double {
            let waterVapor = try waterVapor
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
            let depth = try depth
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
            let increase = try configuration.water.pressure(configuration.units).increase.value
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
                .validate(using: .greater(than: 0)) { .range(.lowerBound($0, 0), callSite) }
            let ambient = try (1 + depth.value / increase)
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
            return Swift.max(ambient - waterVapor.value, .zero)
        }
}
