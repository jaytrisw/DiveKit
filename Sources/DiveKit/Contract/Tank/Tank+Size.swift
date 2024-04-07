import Foundation

public extension Tank {
    struct Size {
        public let volume: Volume
        public let ratedPressure: Pressure
        public let unit: Units.Volume

        public init(volume: Volume, ratedPressure: Pressure, unit: Units.Volume) {
            self.volume = volume
            self.ratedPressure = ratedPressure
            self.unit = unit
        }
    }
}

extension Tank.Size: Equatable {}
