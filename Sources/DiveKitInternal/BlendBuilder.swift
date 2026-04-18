import Foundation
import DiveKitCore

/// A result builder for constructing blends from fractional pressures.
///
/// ``BlendBuilder`` enables a declarative syntax for defining gas mixtures by
/// combining multiple ``DiveKitCore/FractionalPressure`` components into a single
/// ``DiveKitCore/Blend``.
///
/// Each component represents a gas and its fractional pressure. The builder
/// aggregates those components into a ``DiveKitCore/Blend`` with the state requested by the
/// receiving initializer.
///
/// ```swift
/// let blend = Blend<Unblended> {
///     FractionalPressure(Oxygen(), fractionalPressure: 0.21)
///     FractionalPressure(Nitrogen(), fractionalPressure: 0.79)
/// }
/// ```
///
/// - Note: The resulting ``DiveKitCore/Blend`` is not automatically validated. Call ``blend(_:)``
///   to ensure the total pressure satisfies required invariants (e.g., sums to `1`).
/// - Since: 1.0.0
@resultBuilder
package enum BlendBuilder {

    /// Combines multiple ``DiveKitCore/FractionalPressure`` components into a ``DiveKitCore/Blend``.
    ///
    /// - Parameter components: A variadic list of fractional pressures representing
    ///   the gases in the mixture.
    /// - Returns: A ``DiveKitCore/Blend`` containing the provided gas components.
    ///
    /// - Important: The sum of the provided fractional pressures is not validated
    ///   by this method.
    /// - Since: 1.0.0
    package static func buildBlock<each Gas: GasRepresentable, State: BlendState>(
        _ components: repeat FractionalPressure<each Gas>) -> Blend<State> {
            .init(repeat ((each components).gas, (each components).value))
        }
}
