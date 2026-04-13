import Foundation
import DiveKitCore

package extension Double {
    /// Pairs this value with another value produced by a throwing closure.
    ///
    /// Use this helper when a calculation needs to keep the original `Double`
    /// alongside a derived value without introducing a temporary local.
    ///
    /// - Parameter transform: A closure that produces the paired value.
    /// - Returns: A `Tuple` where `first` is `self` and `second` is the result of `transform`.
    /// - Throws: The `DiveKitCore.Error` thrown by `transform`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let absoluteAndConsumption = try absolutePressure.with {
    ///     try calculator.depthAirConsumption(
    ///         for: minutes,
    ///         consuming: gasConsumed,
    ///         with: configuration,
    ///         callSite
    ///     ).result.value
    /// }
    /// ```
    ///
    /// - Note: This method does not validate either value. It only preserves
    ///   ordering while forwarding typed domain errors from `transform`.
    /// - Since: 1.0.0
    func with(
        _ transform: () throws(Error) -> Self) throws(Error) -> Tuple<Self, Self> {
            try .init(first: self, second: transform())
        }
}

package extension Double {
    /// Pairs this value with the result of transforming it.
    ///
    /// The closure receives `self`, and the returned tuple keeps both the
    /// original value and the transformed result available to the next step in
    /// a calculation pipeline.
    ///
    /// - Parameter transform: A closure that derives a value from `self`.
    /// - Returns: A `Tuple` where `first` is `self` and `second` is the transformed value.
    /// - Throws: The `DiveKitCore.Error` thrown by `transform`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pair = try 4.0.with { pressure in
    ///     try pressure.validate(using: .greater(than: .zero)) {
    ///         .range(.lowerBound($0, .zero), callSite)
    ///     }
    /// }
    /// ```
    ///
    /// - Since: 1.0.0
    func with<Other>(
        _ transform: (Self) throws(Error) -> Other) throws(Error) -> Tuple<Self, Other> {
            try .init(first: self, second: transform(self))
        }
}
