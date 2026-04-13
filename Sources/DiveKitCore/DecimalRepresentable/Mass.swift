import Foundation

/// A mass or weight value used by diving calculations.
///
/// `Mass` stores the numeric amount independently from units. The active
/// `Configuration` determines whether the value is interpreted as pounds or
/// kilograms in calculation results.
///
/// ## Example
///
/// ```swift
/// let weight = Mass(12)
/// ```
///
/// - Since: 1.0.0
public struct Mass: Sendable, Equatable, Hashable {
    /// The raw numeric mass or weight.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a mass value.
    ///
    /// - Parameter value: The raw numeric mass or weight.
    /// - Since: 1.0.0
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Mass {
    /// Units used to express mass or weight.
    ///
    /// - Since: 1.0.0
    enum Unit: UnitRepresentable {
        /// Pounds, used by imperial configurations.
        ///
        /// - Since: 1.0.0
        case pounds
        /// Kilograms, used by metric configurations.
        ///
        /// - Since: 1.0.0
        case kilograms
    }
}

/// Allows `Mass` to be used as a decimal calculation result.
///
/// - Since: 1.0.0
extension Mass: DecimalResultRepresentable {}
/// Allows mass units to be encoded and decoded.
///
/// - Since: 1.0.0
extension Mass.Unit: Codable {}
/// Allows mass units to be used in hashed collections.
///
/// - Since: 1.0.0
extension Mass.Unit: Hashable {}
/// Allows mass units to be compared for equality.
///
/// - Since: 1.0.0
extension Mass.Unit: Equatable {}
