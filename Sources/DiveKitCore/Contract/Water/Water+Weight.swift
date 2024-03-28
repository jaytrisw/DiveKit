import Foundation

public extension Water {
    struct Weight {
        public let value: Double
        public let unit: Units.Weight
        public let volume: Units.Volume

        public init(
            _ value: Double,
            unit: Units.Weight,
            per volume: Units.Volume) {
                self.value = value
                self.unit = unit
                self.volume = volume
            }

        public init(
            _ value: Double, units: Units) {
                self.init(value, unit: units.weight, per: units.volume)
            }
    }
}

extension Water.Weight: Equatable {}
