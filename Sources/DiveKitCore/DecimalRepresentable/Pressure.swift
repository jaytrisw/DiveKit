import Foundation

/// A pressure value used by diving calculations.
///
/// `Pressure` stores the numeric amount independently from units. A
/// `DecimalResult<Pressure>` carries the unit used for presentation.
///
/// ## Example
///
/// ```swift
/// let pressure = Pressure(200)
/// ```
///
/// - Since: 1.0.0
public struct Pressure: Sendable, Equatable, Hashable {
    /// The raw numeric pressure.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a pressure value.
    ///
    /// - Parameter value: The raw numeric pressure.
    /// - Since: 1.0.0
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Pressure {
    /// Units used to express pressure.
    ///
    /// - Since: 1.0.0
    enum Unit: UnitRepresentable {
        /// Pounds per square inch, used by imperial configurations.
        ///
        /// - Since: 1.0.0
        case psi
        /// Bar, used by metric configurations.
        ///
        /// - Since: 1.0.0
        case bar
        /// Atmospheres, used for absolute and gauge pressure calculations.
        ///
        /// - Since: 1.0.0
        case atmospheres
    }
}

/// Allows `Pressure` to be used as a decimal calculation result.
///
/// - Since: 1.0.0
extension Pressure: DecimalResultRepresentable {}
/// Allows pressure units to be encoded and decoded.
///
/// - Since: 1.0.0
extension Pressure.Unit: Codable {}
/// Allows pressure units to be used in hashed collections.
///
/// - Since: 1.0.0
extension Pressure.Unit: Hashable {}
/// Allows pressure units to be compared for equality.
///
/// - Since: 1.0.0
extension Pressure.Unit: Equatable {}
