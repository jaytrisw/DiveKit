import Foundation

/// A numeric domain value that can be wrapped in a `DecimalResult`.
///
/// Conforming types expose a raw `Double` and a unit type. The unit type is
/// provided by the calculation result, not by the raw value itself.
///
/// - Since: 1.0.0
public protocol DecimalResultRepresentable: Equatable, ResultRepresentable {
    /// The unit type used when this value appears in a `DecimalResult`.
    ///
    /// - Since: 1.0.0
    associatedtype Unit: UnitRepresentable

    /// The raw numeric value.
    ///
    /// - Since: 1.0.0
    var value: Double { get }
}
