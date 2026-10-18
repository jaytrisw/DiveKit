import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension BuhlmannCalculator {
    /// The model and ascent settings of a ``BuhlmannCalculator``.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct Settings: Sendable, Equatable {
        /// The coefficient table for tissues created by ``BuhlmannCalculator/surfaceTissues()``.
        ///
        /// Tissues keep the table they were created with; see ``Tissues/table``.
        ///
        /// - Since: 1.0.0
        public var table: Buhlmann.Table

        /// The gradient factors.
        ///
        /// The ceiling uses the low gradient factor, the no-decompression limit
        /// uses the high one, and a schedule uses both.
        ///
        /// - Since: 1.0.0
        public var gradientFactors: GradientFactors

        /// The ascent rate and stop depths, in the configured units.
        ///
        /// - Since: 1.0.0
        public var ascent: AscentProfile

        /// The alveolar water vapor pressure in atmospheres.
        ///
        /// - Since: 1.0.0
        public var waterVapor: Pressure

        /// The oxygen partial pressure that sets each switch gas's switch depth.
        ///
        /// - Since: 1.0.0
        public var switchPartialPressure: PartialPressure<Oxygen>

        /// Returns the default settings for a unit system.
        ///
        /// The defaults are ``Buhlmann/Table/zhl16c``, gradient factors of
        /// ``GradientFactors/full``, ``Tissue/alveolarWaterVapor``, and gas
        /// switches at an oxygen partial pressure of 1.6. Ascents are 9 m/min
        /// with stops every 3 m up to a last stop at 3 m, or 30 ft/min with
        /// stops every 10 ft up to a last stop at 10 ft.
        ///
        /// These follow common practice rather than one planner. 30 ft/min
        /// (9 m/min) is the ascent rate of the U.S. Navy Diving Manual,
        /// Revision 7 (2016). The 3 m stop grid with a last stop at 3 m is the
        /// one in A. A. Bühlmann, *Tauchmedizin* (2002); 10 ft is its imperial
        /// equivalent. An oxygen partial pressure of 1.6 is the single-exposure
        /// maximum in the NOAA Diving Manual and the usual limit for
        /// decompression gases.
        ///
        /// - Parameter units: The units the ascent is in.
        /// - Returns: The default settings.
        ///
        /// ```swift
        /// let settings = BuhlmannCalculator.Settings.defaults(for: .imperial)
        /// ```
        ///
        /// - Since: 1.0.0
        public static func defaults(for units: Units) -> Self {
            let ascent: AscentProfile = switch units {
                case .metric: .init(unchecked: .init(9), stopInterval: .init(3), lastStop: .init(3))
                case .imperial: .init(unchecked: .init(30), stopInterval: .init(10), lastStop: .init(10))
            }
            return .init(
                table: .zhl16c,
                gradientFactors: .full,
                ascent: ascent,
                waterVapor: Tissue.alveolarWaterVapor,
                switchPartialPressure: .init(1.6))
        }
    }
}
