import Foundation
import DiveKitCore

package extension Configuration {
    /// Returns the water model's depth increase per atmosphere, validated for use
    /// in depth and pressure conversions.
    ///
    /// - Parameter callSite: The location where the calculation was requested.
    /// - Returns: The depth increase equivalent to one atmosphere, in the
    ///   configuration's depth unit.
    /// - Throws: ``DiveKitCore/Error/range(_:_:)`` with an upper bound if the
    ///   increase is not finite, or with a lower bound if it is not greater than zero.
    ///
    /// ```swift
    /// let increase = try configuration.pressureIncrease(callSite)
    /// ```
    ///
    /// - Since: 1.0.0
    func pressureIncrease(_ callSite: CallSite) throws(Error) -> Double {
        try water.pressure(units).increase.value
            .validatedFinite(callSite)
            .validate(using: .greater(than: 0)) { .range(.lowerBound($0, 0), callSite) }
    }

    /// Returns the water model's weight per unit volume, validated for use in
    /// buoyancy and volume calculations.
    ///
    /// - Parameter callSite: The location where the calculation was requested.
    /// - Returns: The weight of one unit of displaced water in the
    ///   configuration's mass and volume units.
    /// - Throws: ``DiveKitCore/Error/range(_:_:)`` with an upper bound if the
    ///   weight is not finite, or with a lower bound if it is not greater than zero.
    ///
    /// ```swift
    /// let weight = try configuration.waterWeight(callSite)
    /// ```
    ///
    /// - Since: 1.0.0
    func waterWeight(_ callSite: CallSite) throws(Error) -> Double {
        try water.weight(units).value
            .validatedFinite(callSite)
            .validate(using: .greater(than: 0)) { .range(.lowerBound($0, 0), callSite) }
    }
}
