import Foundation

/// A water model used for density and pressure calculations.
///
/// `Water` stores closures so one model can produce unit-specific weight and
/// pressure values for both metric and imperial configurations.
///
/// - Since: 1.0.0
public struct Water: Sendable {
    /// Produces the water weight density for a unit system.
    ///
    /// - Since: 1.0.0
    public let weight: @Sendable (Units) -> Weight

    /// Produces the pressure increase model for a unit system.
    ///
    /// - Since: 1.0.0
    public let pressure: @Sendable (Units) -> Pressure

    /// Creates a water model.
    ///
    /// - Parameters:
    ///   - weight: A closure that returns water weight density for a unit system.
    ///   - pressure: A closure that returns pressure increase for a unit system.
    /// - Since: 1.0.0
    public init(
        weight: @escaping @Sendable (Units) -> Weight,
        pressure: @escaping @Sendable (Units) -> Pressure) {
            self.weight = weight
            self.pressure = pressure
        }
}
