import Foundation
import DiveKitCore

package extension Calculation {
    /// Creates a calculation representing a gas partial pressure.
    ///
    /// This convenience factory wraps the raw partial-pressure value in the
    /// strongly typed `PartialPressure<Gas>` result and preserves the
    /// configuration used by the calculation.
    ///
    /// - Parameters:
    ///   - value: The calculated partial-pressure value.
    ///   - configuration: The calculation configuration.
    /// - Returns: A calculation containing `PartialPressure<Gas>`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let calculation: Calculation<PartialPressure<Oxygen>> = .partialPressure(
    ///     1.28,
    ///     configuration: configuration
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    static func partialPressure<Gas: GasRepresentable>(
        _ value: Double,
        configuration: Configuration) -> Self where Result == PartialPressure<Gas> {
            self.init(
                result: .init(value),
                configuration: configuration)
        }
}
