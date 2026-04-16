import Foundation
import DiveKitCore

package extension Blend where State == Blended {
    /// Creates a blended gas mixture from a list of fractional pressures.
    ///
    /// This initializer allows constructing a `Blend` in the `Blended` state by passing
    /// multiple `FractionalPressure` values directly.
    ///
    /// - Parameter fractionalPressures: A variadic list of fractional pressures.
    ///
    /// ```swift
    /// let blend = Blend<Blended>(
    ///     FractionalPressure(Oxygen(), fractionalPressure: 0.21),
    ///     FractionalPressure(Nitrogen(), fractionalPressure: 0.79)
    /// )
    /// ```
    ///
    /// - Note: The provided values are assumed to already form a valid blended state.
    /// - Since: 1.0.0
    init<each Gas: GasRepresentable>(_ fractionalPressures: repeat FractionalPressure<each Gas>) {
        self.init(repeat ((each fractionalPressures).gas, (each fractionalPressures).value))
    }
}

public extension Blend where State == Unblended {
    /// Creates an unblended gas mixture from a list of fractional pressures.
    ///
    /// This initializer allows constructing a `Blend` in the `Unblended` state by passing
    /// multiple `FractionalPressure` values directly.
    ///
    /// - Parameter fractionalPressures: A variadic list of fractional pressures.
    ///
    /// ```swift
    /// let blend = Blend<Unblended>(
    ///     FractionalPressure(Oxygen(), fractionalPressure: 0.32),
    ///     FractionalPressure(Nitrogen(), fractionalPressure: 0.68)
    /// )
    /// ```
    ///
    /// - Note: The resulting blend may require validation using `blend()`
    ///   before it can be used as a `Blended` state.
    /// - Since: 1.0.0
    init<each Gas: GasRepresentable>(_ fractionalPressures: repeat FractionalPressure<each Gas>) {
        self.init(repeat ((each fractionalPressures).gas, (each fractionalPressures).value))
    }
}
