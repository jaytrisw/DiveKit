import Foundation
import DiveKitCore

package extension Calculation {
    /// Pairs this calculation with another calculation.
    ///
    /// Use this helper when a later step needs both the current calculation and
    /// another calculation derived from the same inputs.
    ///
    /// - Parameter other: A closure that produces another `Calculation`.
    /// - Returns: A `Tuple` where `first` is `self` and `second` is the result of `other`.
    /// - Throws: The `DiveKitCore.Error` thrown by `other`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let combined = try absolutePressure.with {
    ///     try calculator.depthAirConsumption(
    ///         for: minutes,
    ///         consuming: gasConsumed,
    ///         with: configuration,
    ///         callSite
    ///     )
    /// }
    /// ```
    ///
    /// - Note: The method does not merge configurations or results. It only
    ///   preserves both calculations in their original form.
    /// - Since: 1.0.0
    func with(_ other: () throws(Error) -> Calculation) throws(Error) -> Tuple<Self, Self> {
        .init(first: self, second: try other())
    }
}
