import Foundation

/// A numeric calculation result paired with its unit.
///
/// `DecimalResult` is used when the calculation output is a domain decimal
/// value such as `Depth`, `Pressure`, `Volume`, or `Rate`.
///
/// - Since: 1.0.0
public struct DecimalResult<Decimal: DecimalResultRepresentable>: Sendable {
    /// The raw numeric result.
    ///
    /// - Since: 1.0.0
    public var value: Double

    /// The unit associated with `value`.
    ///
    /// - Since: 1.0.0
    public let unit: Decimal.Unit

    /// Creates a decimal result.
    ///
    /// - Parameters:
    ///   - value: The raw numeric result.
    ///   - unit: The unit associated with `value`.
    /// - Since: 1.0.0
    package init(_ value: Double, unit: Decimal.Unit) {
        self.value = value
        self.unit = unit
    }
}

/// Allows decimal results to be compared when their generic value types match.
///
/// - Since: 1.0.0
extension DecimalResult: Equatable {}
/// Allows decimal results to be stored in `Calculation`.
///
/// - Since: 1.0.0
extension DecimalResult: ResultRepresentable {}
