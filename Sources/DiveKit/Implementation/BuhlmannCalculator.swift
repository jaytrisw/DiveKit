import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

/// A calculator for decompression with the Bühlmann ZH-L16 model and gradient factors.
///
/// `BuhlmannCalculator` tracks inert gas in a diver's tissues as ``Tissues``.
/// Start from ``surfaceTissues()``, load the dive with ``loaded(_:through:)``,
/// then ask for the ``ceiling(of:)``, the
/// ``noDecompressionLimit(of:at:breathing:)`` or an ascent
/// ``schedule(of:from:breathing:switchingTo:)``.
///
/// All calculations use the provided configuration and ``settings``. Loading
/// always uses ``Tissue/Loading/schreiner``.
///
/// The ceiling uses the low gradient factor, while the no-decompression limit
/// and a direct ascent use the high one. With different gradient factors, a
/// dive can have a ceiling below the surface and still be within its
/// no-decompression limit.
///
/// ```swift
/// let calculator = BuhlmannCalculator(configuration: .init(units: .metric, water: .salt))
/// let tissues = try calculator.loaded(
///     try calculator.surfaceTissues(),
///     through: [
///         try DiveSegment(start: .init(0), end: .init(40), duration: .init(2), blend: .air),
///         try DiveSegment(start: .init(40), end: .init(40), duration: .init(25), blend: .air)
///     ])
/// let schedule = try calculator.schedule(
///     of: tissues,
///     from: .init(40),
///     breathing: .air,
///     switchingTo: [try .enrichedAir(0.5)])
/// ```
///
/// - Warning: See ``Buhlmann`` before relying on this model.
///
/// - Since: 1.0.0
@_spi(Experimental)
final public class BuhlmannCalculator: ConfigurationProviding {

    /// The configuration used for all calculations.
    ///
    /// - Since: 1.0.0
    public let configuration: Configuration

    /// The model and ascent settings used for all calculations.
    ///
    /// - Since: 1.0.0
    public let settings: Settings

    /// Creates a calculator with the default settings for the configured units.
    ///
    /// - Parameter configuration: The configuration used for calculations.
    ///
    /// ```swift
    /// let calculator = BuhlmannCalculator(configuration: configuration)
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    required public convenience init(configuration: Configuration) {
        self.init(configuration: configuration, settings: .defaults(for: configuration.units))
    }

    /// Creates a calculator.
    ///
    /// - Parameters:
    ///   - configuration: The configuration used for calculations.
    ///   - settings: The model and ascent settings. Depths in `settings.ascent`
    ///     are in the configured units.
    ///
    /// ```swift
    /// var settings = BuhlmannCalculator.Settings.defaults(for: .metric)
    /// settings.gradientFactors = try .init(low: try .init(0.3), high: try .init(0.85))
    /// let calculator = BuhlmannCalculator(configuration: configuration, settings: settings)
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    public init(configuration: Configuration, settings: Settings) {
        self.configuration = configuration
        self.settings = settings
    }
}

@_spi(Experimental)
public extension BuhlmannCalculator {
    /// The inert-gas loading of a diver's tissues under a Bühlmann table.
    ///
    /// Tissues are created by ``BuhlmannCalculator/surfaceTissues()`` and
    /// ``BuhlmannCalculator/loaded(_:through:)``. They keep the table they were
    /// created with, and every calculation on them uses that table, even on a
    /// calculator whose ``Settings/table`` differs.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Tissues: Sendable, Equatable {
        /// The table the tissues' compartments are checked against.
        ///
        /// - Since: 1.0.0
        public let table: Buhlmann.Table

        /// One compartment per row of ``table``.
        let compartments: [Tissue.Compartment]
    }
}

@_spi(Experimental)
extension BuhlmannCalculator: DecompressionCalculating {
    /// Returns tissues saturated at the surface on air.
    ///
    /// Each compartment holds nitrogen at `(1 − P_wv) · f_N₂` atmospheres, where
    /// `P_wv` is ``Settings/waterVapor`` and `f_N₂` is the nitrogen fraction of
    /// `Blend.air`, and no helium. There is one compartment per row of
    /// ``Settings/table``.
    ///
    /// - Returns: The tissues before a dive.
    /// - Throws: `Error.negative` if ``Settings/waterVapor`` is negative, or
    ///   `Error.range` if it is not finite, or if the configured water's depth
    ///   per atmosphere is not finite or not greater than `0`.
    ///
    /// ```swift
    /// let tissues = try calculator.surfaceTissues()
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    public func surfaceTissues() throws(DiveKit.Error) -> Tissues {
        let breathed = try Tissue.breathedPressure(at: .init(.zero), waterVapor: settings.waterVapor, configuration: configuration, .from(self))
        return .init(
            table: settings.table,
            compartments: try settings.table.compartments(nitrogen: .init(breathed * Blend.air.fractionalPressure(of: .nitrogen))))
    }

    /// Returns tissues after a dive profile.
    ///
    /// Each segment is loaded in order, as for
    /// ``Tissue/Inspired/init(of:breathing:from:to:waterVapor:configuration:)``
    /// and ``Tissue/Compartment/loaded(for:inspired:using:)`` with
    /// ``Settings/waterVapor`` and ``Tissue/Loading/schreiner``. Inert gases
    /// the tissues do not track are ignored.
    ///
    /// - Parameters:
    ///   - tissues: The tissues at the start of the profile.
    ///   - profile: The segments, in order, with depths in the configured units.
    /// - Returns: The tissues at the end of the profile, with the same table.
    /// - Throws: `Error.negative` if ``Settings/waterVapor`` is negative, or
    ///   `Error.range` if it is not finite, if the configured water's depth per
    ///   atmosphere is not finite or not greater than `0`, or if the ambient
    ///   pressure at a segment depth or a loaded tension is not finite.
    ///
    /// ```swift
    /// let tissues = try calculator.loaded(
    ///     try calculator.surfaceTissues(),
    ///     through: [try DiveSegment(start: .init(0), end: .init(30), duration: .init(1.5), blend: .air)])
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    public func loaded(_ tissues: Tissues, through profile: [DiveSegment]) throws(DiveKit.Error) -> Tissues {
        let callSite: CallSite = .from(self)
        let waterVapor = try Tissue.validatedWaterVapor(settings.waterVapor, callSite)
        let increase = try configuration.pressureIncrease(callSite)
        var compartments = tissues.compartments
        for segment in profile {
            let breathed = try Tissue.breathedPressures(
                from: segment.start,
                to: segment.end,
                waterVapor: waterVapor,
                increase: increase,
                callSite)
            let fractions = segment.blend.fractions
            compartments = try compartments.map { (compartment: Tissue.Compartment) throws(DiveKit.Error) in
                try compartment.loaded(for: segment.duration.value, breathing: fractions, breathed: breathed, using: .schreiner, callSite)
            }
        }
        return .init(table: tissues.table, compartments: compartments)
    }

    /// Calculates the shallowest depth the tissues tolerate at the low gradient factor.
    ///
    /// The low gradient factor is the one the first decompression stop is
    /// chosen with. The ceiling is calculated as for
    /// ``Buhlmann/Table/ceiling(of:gradientFactor:configuration:)`` with the
    /// tissues' table.
    ///
    /// The no-decompression limit and a schedule's direct-ascent check use the
    /// high gradient factor instead. When the gradient factors differ, the
    /// ceiling can be below the surface while
    /// ``noDecompressionLimit(of:at:breathing:)`` is still a number of minutes
    /// and ``schedule(of:from:breathing:switchingTo:)`` is a direct ascent with
    /// no stops.
    ///
    /// - Parameter tissues: The tissues.
    /// - Returns: A calculation containing the ceiling depth, or `0` if the
    ///   tissues tolerate the surface.
    /// - Throws: The errors of
    ///   ``Buhlmann/Table/ceiling(of:gradientFactor:configuration:)``.
    ///
    /// ```swift
    /// let ceiling = try calculator.ceiling(of: tissues)
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    public func ceiling(of tissues: Tissues) throws(DiveKit.Error) -> Calculation<DecimalResult<Depth>> {
        try tissues.table.ceiling(
            of: tissues.compartments,
            gradientFactor: settings.gradientFactors.low,
            configuration: configuration,
            .from(self))
    }

    /// Calculates how long the tissues can stay at a depth and still ascend directly to the surface.
    ///
    /// The high gradient factor, which applies at the surface, is used. The
    /// limit is calculated as for
    /// ``Buhlmann/Table/noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)``
    /// with the tissues' table, ``Settings/waterVapor``, and
    /// ``Tissue/Loading/schreiner``.
    ///
    /// - Parameters:
    ///   - tissues: The tissues on arrival at `depth`.
    ///   - depth: The depth, in the configured units.
    ///   - blend: The breathing gas.
    /// - Returns: A calculation containing the no-decompression limit.
    /// - Throws: The errors of
    ///   ``Buhlmann/Table/noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)``.
    ///
    /// ```swift
    /// let limit = try calculator.noDecompressionLimit(of: tissues, at: .init(30), breathing: .air)
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    public func noDecompressionLimit(
        of tissues: Tissues,
        at depth: Depth,
        breathing blend: Blend<Blended>) throws(DiveKit.Error) -> Calculation<NoDecompressionLimit> {
            .init(
                result: try tissues.table.noDecompressionLimit(
                    of: tissues.compartments,
                    at: depth,
                    breathing: blend,
                    gradientFactor: settings.gradientFactors.high,
                    waterVapor: settings.waterVapor,
                    configuration: configuration,
                    .from(self)),
                configuration: configuration)
        }

    /// Calculates an ascent from depth to the surface, with decompression stops and gas switches.
    ///
    /// Each gas in `gases` is switched to at its maximum operating depth for
    /// ``Settings/switchPartialPressure``, calculated as for
    /// ``GasCalculator/maximumOperatingDepth(for:in:)``. If two gases have the
    /// same switch depth, the first in `gases` is used.
    ///
    /// The depth is not rounded to the stop grid: from the first stop on, a gas
    /// is switched to at the first stop at or above its switch depth. For
    /// example, oxygen at 1.6 in salt water has a maximum operating depth of
    /// about 19.8 ft, so on the default 10 ft grid it is switched to at 10 ft,
    /// not 20 ft. A gas whose switch depth is shallower than
    /// ``Ascent/lastStop`` is never used, so with a 20 ft last stop that oxygen
    /// is not breathed.
    ///
    /// For other switch depths, use
    /// ``Buhlmann/Table/schedule(of:from:breathing:switches:gradientFactors:ascent:waterVapor:configuration:using:)``.
    ///
    /// The ascent is calculated as for that method with the tissues' table,
    /// ``Settings/gradientFactors``, ``Settings/ascent``,
    /// ``Settings/waterVapor``, and ``Tissue/Loading/schreiner``. As there, a
    /// gas whose switch depth is at or deeper than `depth` is breathed from the
    /// start instead of `blend`.
    ///
    /// - Parameters:
    ///   - tissues: The tissues at the start of the ascent.
    ///   - depth: The depth at the start of the ascent, in the configured units.
    ///   - blend: The gas breathed at the start of the ascent.
    ///   - gases: Gases to switch to during the ascent.
    /// - Returns: A calculation containing the schedule, which is empty if
    ///   `depth` is `0`.
    /// - Throws: `Error.negative` if ``Settings/switchPartialPressure`` is
    ///   negative, or if a gas's oxygen fraction is above it, since its switch
    ///   depth would then be above the surface; `Error.range` if it is not
    ///   finite or is zero, even when `gases` is empty; the errors of
    ///   ``GasCalculator/maximumOperatingDepth(for:in:)`` for each gas, such as
    ///   `Error.range` if a gas has no oxygen; or the errors of
    ///   ``Buhlmann/Table/schedule(of:from:breathing:switches:gradientFactors:ascent:waterVapor:configuration:using:)``.
    ///
    /// ```swift
    /// let schedule = try calculator.schedule(
    ///     of: tissues,
    ///     from: .init(40),
    ///     breathing: .air,
    ///     switchingTo: [try .enrichedAir(0.5), try .enrichedAir(1)])
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    public func schedule(
        of tissues: Tissues,
        from depth: Depth,
        breathing blend: Blend<Blended>,
        switchingTo gases: [Blend<Blended>]) throws(DiveKit.Error) -> Calculation<DecompressionSchedule> {
            let callSite: CallSite = .from(self)
            try settings.switchPartialPressure
                .validatedFiniteNonNegative(callSite)
                .validate(using: .greater(than: .zero)) { .range(.lowerBound($0.value, .zero), callSite) }
            let gasCalculator = GasCalculator(configuration: configuration)
            var switches: [Depth: Blend<Blended>] = [:]
            for gas in gases {
                let switchDepth = Depth(try gasCalculator.maximumOperatingDepth(for: settings.switchPartialPressure, in: gas, callSite).result.value)
                if switches[switchDepth] == nil {
                    switches[switchDepth] = gas
                }
            }
            return try tissues.table.schedule(
                of: tissues.compartments,
                from: depth,
                breathing: blend,
                switches: switches,
                gradientFactors: settings.gradientFactors,
                ascent: settings.ascent,
                waterVapor: settings.waterVapor,
                configuration: configuration,
                callSite)
        }
}
