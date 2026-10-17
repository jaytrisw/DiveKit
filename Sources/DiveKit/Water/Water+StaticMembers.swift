import Foundation
import DiveKitCore

public extension Water {
    /// A predefined configuration representing salt water.
    ///
    /// This configuration provides standard values for salt water density and
    /// pressure increase per unit depth, based on the selected unit system.
    ///
    /// - Returns: A `Water` instance configured for salt water conditions.
    ///
    /// ```swift
    /// let water = Water.salt
    /// ```
    ///
    /// - Note:
    ///   - Imperial units use a density of `64 lb/ft³` and `33 ft` per
    ///     atmosphere, the feet of sea water (fsw) convention of the U.S. Navy
    ///     Diving Manual, Revision 7 (2016).
    ///   - Metric units use a density of `1.025 kg/L` and `10 m` per
    ///     atmosphere. The `10 m` is the metres of sea water (msw) convention,
    ///     where 10 msw is 1 bar (EN 13319), applied here per atmosphere.
    ///   - The two conventions describe slightly different seas: 33 ft is
    ///     10.058 m, so metric depths gain pressure about 0.6% faster than
    ///     imperial ones. For example, the MOD of EAN32 at 1.4 is 33.75 m
    ///     (110.7 ft) in metric and 111.4 ft in imperial. Both match the
    ///     published tables divers use in each unit system.
    /// - Since: 1.0.0
    static var salt: Self {
        .init(
            weight: { .init($0 == .imperial ? 64 : 1.025, units: $0) },
            pressure: { .init(increase: .init($0 == .imperial ? 33 : 10, units: $0)) })
    }

    /// A predefined configuration representing fresh water.
    ///
    /// This configuration provides standard values for fresh water density and
    /// pressure increase per unit depth, based on the selected unit system.
    ///
    /// - Returns: A `Water` instance configured for fresh water conditions.
    ///
    /// ```swift
    /// let water = Water.fresh
    /// ```
    ///
    /// - Note:
    ///   - Imperial units use a density of `62.4 lb/ft³` and `34 ft` per
    ///     atmosphere, the fresh-water values of the U.S. Navy Diving Manual,
    ///     Revision 7 (2016).
    ///   - Metric units use a density of `1.0 kg/L` and `10.3 m` per
    ///     atmosphere: 101325 Pa / (1000 kg/m³ × 9.80665 m/s²) = 10.33 m.
    ///   - Unlike salt water, the two agree to within 0.3% (34 ft is 10.36 m).
    /// - Since: 1.0.0
    static var fresh: Self {
        .init(
            weight: { .init($0 == .imperial ? 62.4 : 1, units: $0) },
            pressure: { .init(increase: .init($0 == .imperial ? 34 : 10.3, units: $0)) })
    }
}
