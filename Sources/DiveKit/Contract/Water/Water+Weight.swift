import Foundation

public extension Water {
    struct Weight {
        public let value: Double
        public let unit: Mass.Unit
        public let volume: Volume.Unit

        public init(
            _ value: Double,
            unit: Mass.Unit,
            per volume: Volume.Unit) {
                self.value = value
                self.unit = unit
                self.volume = volume
            }

        public init(
            _ value: Double, units: Units) {
                self.init(value, unit: units.mass, per: units.volume)
            }
    }
}

extension Water.Weight: Equatable {}
