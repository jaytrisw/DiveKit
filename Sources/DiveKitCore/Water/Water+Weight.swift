import Foundation

public extension Water {
    /// Water weight density for a unit system.
    ///
    /// `Weight` represents how much a unit volume of water weighs, such as
    /// pounds per cubic foot or kilograms per liter.
    ///
    /// - Since: 1.0.0
    struct Weight: Sendable {
        /// The density value.
        ///
        /// - Since: 1.0.0
        public let value: Double

        /// The mass unit for the density value.
        ///
        /// - Since: 1.0.0
        public let unit: Mass.Unit

        /// The volume unit the mass is measured per.
        ///
        /// - Since: 1.0.0
        public let volume: Volume.Unit

        /// Creates a water weight density.
        ///
        /// - Parameters:
        ///   - value: The density value.
        ///   - unit: The mass unit for the density value.
        ///   - volume: The volume unit the mass is measured per.
        /// - Since: 1.0.0
        public init(
            _ value: Double,
            unit: Mass.Unit,
            per volume: Volume.Unit) {
                self.value = value
                self.unit = unit
                self.volume = volume
            }

        /// Creates a water weight density using units from a unit system.
        ///
        /// - Parameters:
        ///   - value: The density value.
        ///   - units: The unit system that supplies mass and volume units.
        /// - Since: 1.0.0
        public init(
            _ value: Double, units: Units) {
                self.init(value, unit: units.mass, per: units.volume)
            }
    }
}

/// Allows water weight densities to be compared by value and units.
///
/// - Since: 1.0.0
extension Water.Weight: Equatable {}
