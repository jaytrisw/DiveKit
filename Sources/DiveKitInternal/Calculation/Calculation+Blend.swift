import Foundation
import DiveKitCore

package extension Calculation {
    /// Creates a calculation representing a blended gas mixture.
    ///
    /// - Parameters:
    ///   - blend: The blended gas mixture.
    ///   - configuration: The calculation configuration.
    /// - Returns: A calculation containing the provided blend.
    ///
    /// ```swift
    /// let calculation = Calculation.blend(
    ///     blend,
    ///     configuration: configuration)
    /// ```
    ///
    /// - Note: This method does not perform validation. The `blend` is expected
    ///   to already be in a valid ``DiveKitCore/Blended`` state.
    /// - Since: 1.0.0
    static func blend(
        _ blend: Blend<Blended>,
        configuration: Configuration) -> Self where Result == Blend<Blended> {
            self.init(
                result: blend,
                configuration: configuration)
        }
}
