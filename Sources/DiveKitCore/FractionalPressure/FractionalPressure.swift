import Foundation

/// A gas and its fractional pressure in a blend.
///
/// `FractionalPressure` pairs a concrete gas type with a raw fraction. Public
/// construction that validates the range lives in the top-level `DiveKit`
/// module.
///
/// - Since: 1.0.0
public struct FractionalPressure<Gas: GasRepresentable>: Sendable {
    /// The gas represented by this fraction.
    ///
    /// - Since: 1.0.0
    public let gas: Gas

    /// The raw fractional pressure.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a fractional pressure without validation.
    ///
    /// - Parameters:
    ///   - gas: The gas represented by this fraction.
    ///   - fractionalPressure: The raw fractional pressure.
    /// - Warning: This package initializer does not validate that
    ///   `fractionalPressure` is within `0...1`.
    /// - Since: 1.0.0
    package init(_ gas: Gas, fractionalPressure: Double) {
        self.gas = gas
        self.value = fractionalPressure
    }
}

/// Allows fractional pressures to be compared.
///
/// - Since: 1.0.0
extension FractionalPressure: Equatable {}
/// Allows fractional pressures to be used in hashed collections.
///
/// - Since: 1.0.0
extension FractionalPressure: Hashable {}
/// Allows fractional pressures to be stored in `Calculation`.
///
/// - Since: 1.0.0
extension FractionalPressure: ResultRepresentable {}
