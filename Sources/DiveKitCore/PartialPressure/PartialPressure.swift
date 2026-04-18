import Foundation

/// The partial pressure of a gas.
///
/// `PartialPressure` preserves the gas type at compile time while storing the
/// raw pressure value in atmospheres.
///
/// - Since: 1.0.0
public struct PartialPressure<Gas: GasRepresentable>: Sendable, Equatable, Hashable {
    /// The raw partial-pressure value.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// The unit used for partial pressure values.
    ///
    /// - Returns: `.atmospheres`.
    /// - Since: 1.0.0
    public var unit: Pressure.Unit {
        .atmospheres
    }

    /// Creates a partial pressure value.
    ///
    /// - Parameter value: The raw partial-pressure value.
    /// - Since: 1.0.0
    public init(_ value: Double) {
        self.value = value
    }
}

/// Allows partial pressures to be stored in `Calculation`.
///
/// - Since: 1.0.0
extension PartialPressure: ResultRepresentable {}
