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
    ///   - Imperial units use a density of `64 lb/ft³` and `33 ft` per atmosphere.
    ///   - Metric units use a density of `1.03 kg/L` and `10 m` per atmosphere.
    /// - Since: 1.0.0
    static var salt: Self {
        .init(
            weight: { .init($0 == .imperial ? 64 : 1.03, units: $0) },
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
    ///   - Imperial units use a density of `62.4 lb/ft³` and `34 ft` per atmosphere.
    ///   - Metric units use a density of `1.0 kg/L` and `10.3 m` per atmosphere.
    /// - Since: 1.0.0
    static var fresh: Self {
        .init(
            weight: { .init($0 == .imperial ? 62.4 : 1, units: $0) },
            pressure: { .init(increase: .init($0 == .imperial ? 34 : 10.3, units: $0)) })
    }
}
