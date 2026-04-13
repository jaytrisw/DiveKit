import Foundation
import DiveKitCore

package extension Calculation {
    /// Creates a calculation representing a blended gas mixture.
    ///
    /// This convenience method wraps a `Blend<Blended>` value in a `Calculation`,
    /// associating it with the provided configuration.
    ///
    /// - Parameters:
    ///   - blend: The blended gas mixture.
    ///   - configuration: The calculation configuration.
    /// - Returns: A calculation containing the provided blend.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let calculation = Calculation.blend(
    ///     blend,
    ///     configuration: configuration
    /// )
    /// ```
    ///
    /// - Note: This method does not perform validation. The `blend` is expected
    ///   to already be in a valid `Blended` state.
    /// - Since: 1.0.0
    static func blend(
        _ blend: Blend<Blended>,
        configuration: Configuration) -> Self where Result == Blend<Blended> {
            self.init(
                result: blend,
                configuration: configuration)
        }
}
