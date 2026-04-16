import Foundation

/// A volume value used by diving calculations.
///
/// `Volume` stores the numeric amount independently from units. A
/// `DecimalResult<Volume>` carries the unit used for presentation.
///
/// - Since: 1.0.0
public struct Volume: Sendable, Equatable, Hashable {
    /// The raw numeric volume.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a volume value.
    ///
    /// - Parameter value: The raw numeric volume.
    /// - Since: 1.0.0
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Volume {
    /// Units used to express volume.
    ///
    /// - Since: 1.0.0
    enum Unit: UnitRepresentable {
        /// Liters, used by metric configurations.
        ///
        /// - Since: 1.0.0
        case liters
        /// Cubic feet, used by imperial configurations.
        ///
        /// - Since: 1.0.0
        case cubicFeet
    }
}

/// Allows `Volume` to be used as a decimal calculation result.
///
/// - Since: 1.0.0
extension Volume: DecimalResultRepresentable {}
/// Allows volume units to be encoded and decoded.
///
/// - Since: 1.0.0
extension Volume.Unit: Codable {}
/// Allows volume units to be used in hashed collections.
///
/// - Since: 1.0.0
extension Volume.Unit: Hashable {}
/// Allows volume units to be compared for equality.
///
/// - Since: 1.0.0
extension Volume.Unit: Equatable {}
