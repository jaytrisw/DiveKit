import Foundation

/// A depth value used by diving calculations.
///
/// `Depth` stores the numeric depth independently from display or calculation
/// units. Units are attached to calculation results through `DecimalResult`.
///
/// ## Example
///
/// ```swift
/// let depth = Depth(30)
/// ```
///
/// - Since: 1.0.0
public struct Depth: Sendable, Equatable, Hashable {
    /// The raw numeric depth.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a depth value.
    ///
    /// - Parameter value: The raw numeric depth.
    /// - Since: 1.0.0
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Depth {
    /// Units used to express depth.
    ///
    /// - Since: 1.0.0
    enum Unit: UnitRepresentable {
        /// Feet, used by imperial configurations.
        ///
        /// - Since: 1.0.0
        case feet
        /// Meters, used by metric configurations.
        ///
        /// - Since: 1.0.0
        case meters
    }
}

/// Allows `Depth` to be used as a decimal calculation result.
///
/// - Since: 1.0.0
extension Depth: DecimalResultRepresentable {}
/// Allows depth units to be encoded and decoded.
///
/// - Since: 1.0.0
extension Depth.Unit: Codable {}
/// Allows depth units to be used in hashed collections.
///
/// - Since: 1.0.0
extension Depth.Unit: Hashable {}
/// Allows depth units to be compared for equality.
///
/// - Since: 1.0.0
extension Depth.Unit: Equatable {}
