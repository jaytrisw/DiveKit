import Foundation

/// The buoyancy state of an object.
///
/// Positive buoyancy means the object tends to float, negative buoyancy means
/// it tends to sink, and neutral buoyancy means the forces are balanced.
///
/// - Since: 1.0.0
public enum Buoyancy: Sendable {
    /// Positive buoyancy with the given buoyant force magnitude.
    ///
    /// - Since: 1.0.0
    case positive(_ buoyantForce: Double)
    /// Negative buoyancy with the given buoyant force magnitude.
    ///
    /// - Since: 1.0.0
    case negative(_ buoyantForce: Double)
    /// Neutral buoyancy.
    ///
    /// - Since: 1.0.0
    case neutral
}

/// Allows buoyancy values to be compared.
///
/// - Since: 1.0.0
extension Buoyancy: Equatable {}
/// Allows buoyancy values to be stored in `Calculation`.
///
/// - Since: 1.0.0
extension Buoyancy: ResultRepresentable {}
