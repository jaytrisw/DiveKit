import Foundation
@_spi(Experimental) import DiveKitCore

/// Overrides how narcotic a gas is for a single calculation.
///
/// A treatment never changes the gas itself, so the gas still matches its
/// component in a blend.
///
/// ```swift
/// let end = try calculator.equivalentNarcoticDepth(
///     for: 60,
///     with: .trimix(oxygen: 0.18, helium: 0.45),
///     treating: .narcotic(.oxygen)
/// )
/// ```
///
/// - Since: 1.0.0
@_spi(Experimental)
public struct NarcoticTreatment: Sendable, Hashable {
    /// The gas whose potency is overridden.
    ///
    /// - Since: 1.0.0
    package let gas: AnyGas

    /// The narcotic potency that replaces the gas's own.
    ///
    /// - Since: 1.0.0
    package let potency: NarcoticPotency

    /// Treats a gas as narcotic with the given potency.
    ///
    /// - Parameters:
    ///   - gas: The gas to treat as narcotic.
    ///   - potency: The narcotic potency relative to nitrogen. Defaults to
    ///     nitrogen's potency.
    /// - Returns: A treatment for `gas`.
    ///
    /// ```swift
    /// let oxygen = NarcoticTreatment.narcotic(.oxygen)
    /// ```
    ///
    /// - Note: The potency is validated by the calculation that uses it.
    /// - Since: 1.0.0
    public static func narcotic(_ gas: some GasRepresentable, potency: NarcoticPotency = .nitrogen) -> Self {
        .init(gas: .init(gas), potency: potency)
    }

    /// Treats helium as narcotic with its potency from Bennett (2004), about
    /// 0.2 times that of nitrogen.
    ///
    /// - Parameter gas: Helium.
    /// - Returns: A treatment for helium.
    ///
    /// ```swift
    /// let helium = NarcoticTreatment.bennett(.helium)
    /// ```
    ///
    /// - Since: 1.0.0
    public static func bennett(_ gas: Helium) -> Self {
        .narcotic(gas, potency: .relative(0.2))
    }

    /// Treats oxygen as narcotic with its potency from Bennett (2004), about
    /// 1.7 times that of nitrogen.
    ///
    /// - Parameter gas: Oxygen.
    /// - Returns: A treatment for oxygen.
    ///
    /// ```swift
    /// let oxygen = NarcoticTreatment.bennett(.oxygen)
    /// ```
    ///
    /// - Since: 1.0.0
    public static func bennett(_ gas: Oxygen) -> Self {
        .narcotic(gas, potency: .relative(1.7))
    }
}
