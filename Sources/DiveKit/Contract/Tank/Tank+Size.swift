import Foundation

public extension Tank {
    struct Size {
        public let volume: Volume
        public let ratedPressure: Pressure
        public let unit: Volume.Unit

        public init(volume: Volume, ratedPressure: Pressure, unit: Volume.Unit) {
            self.volume = volume
            self.ratedPressure = ratedPressure
            self.unit = unit
        }
    }
}

extension Tank.Size: Equatable {}
