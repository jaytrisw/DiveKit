import Foundation

/// A namespace for the Bühlmann ZH-L16 decompression model.
///
/// Bühlmann pairs each tissue compartment with coefficients `a` and `b` that
/// define how much dissolved inert gas the compartment tolerates at a given
/// ambient pressure. Loading is delegated to ``Tissue/Compartment``, so the
/// tissue primitives stay independent of any decompression model.
///
/// All pressures are in atmospheres and durations are in minutes. Published
/// tables give `a` in bar; built-in tables convert it once.
///
/// - Warning: This model has not been validated for planning real dives. Do not
///   use it as a substitute for a dive computer, published tables, or training.
///
/// - Important: Surface pressure is fixed at one atmosphere, as at sea level.
///   The model does not adjust for altitude, so at altitude no-decompression
///   limits are too long and ceilings too shallow.
///
/// - Since: 1.0.0
@_spi(Experimental)
public enum Buhlmann {}

extension Buhlmann {
    /// The smallest accepted `b` coefficient and gradient factor.
    ///
    /// Published tables use `b` of about 0.5 to 1. The floor keeps tension-weighted
    /// `b` from rounding to zero and the tolerated-pressure ratio from overflowing.
    static var minimumFactor: Double { 0.01 }
}
