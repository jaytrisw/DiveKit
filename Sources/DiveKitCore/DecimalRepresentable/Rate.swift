import Foundation

/// A rate for a decimal result value.
///
/// `Rate` represents values such as pressure per minute or volume per minute.
/// The base value determines the unit carried by `RateUnit`.
///
/// ## Example
///
/// ```swift
/// let sac = Rate<Pressure>(18)
/// ```
///
/// - Since: 1.0.0
public struct Rate<Value: DecimalResultRepresentable>: Sendable, Equatable, Hashable
    where Value.Unit: Codable & Hashable {

    /// The raw numeric rate.
    ///
    /// - Since: 1.0.0
    public let value: Double

    /// Creates a rate value.
    ///
    /// - Parameter value: The raw numeric rate.
    /// - Since: 1.0.0
    public init(_ value: Double) {
        self.value = value
    }
}

/// Allows `Rate` to be used as a decimal calculation result.
///
/// - Since: 1.0.0
extension Rate: DecimalResultRepresentable {
    /// The unit type for a rate of `Value`.
    ///
    /// - Since: 1.0.0
    public typealias Unit = RateUnit<Value.Unit>
}

/// A per-time unit for a decimal result value.
///
/// `RateUnit` currently represents per-minute rates, such as PSI per minute or
/// liters per minute.
///
/// - Since: 1.0.0
public enum RateUnit<BaseUnit: UnitRepresentable & Codable & Hashable & Equatable>: UnitRepresentable, Sendable {
    /// A rate expressed per minute in the given base unit.
    ///
    /// - Since: 1.0.0
    case perMinute(BaseUnit)
}

/// Allows rate units to be encoded and decoded.
///
/// - Since: 1.0.0
extension RateUnit: Codable {}
/// Allows rate units to be used in hashed collections.
///
/// - Since: 1.0.0
extension RateUnit: Hashable {}
/// Allows rate units to be compared for equality.
///
/// - Since: 1.0.0
extension RateUnit: Equatable {}
