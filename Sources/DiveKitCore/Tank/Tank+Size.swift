import Foundation

public extension Tank {
    /// The physical size and rated pressure of a tank.
    ///
    /// `Size` stores the tank volume, rated pressure, and the volume unit used
    /// to interpret the size.
    ///
    /// - Since: 1.0.0
    struct Size: Sendable {
        /// The tank volume.
        ///
        /// - Since: 1.0.0
        public let volume: Volume

        /// The pressure at which the tank volume is rated.
        ///
        /// - Since: 1.0.0
        public let ratedPressure: Pressure

        /// The unit used for `volume`.
        ///
        /// - Since: 1.0.0
        public let unit: Volume.Unit

        /// Creates a tank size.
        ///
        /// - Parameters:
        ///   - volume: The tank volume.
        ///   - ratedPressure: The pressure at which the tank volume is rated.
        ///   - unit: The unit used for `volume`.
        /// - Since: 1.0.0
        public init(volume: Volume, ratedPressure: Pressure, unit: Volume.Unit) {
            self.volume = volume
            self.ratedPressure = ratedPressure
            self.unit = unit
        }
    }
}

/// Allows tank sizes to be compared by volume, rated pressure, and unit.
///
/// - Since: 1.0.0
extension Tank.Size: Equatable {}
