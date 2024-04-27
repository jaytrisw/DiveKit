import Foundation

public extension Water {
    struct Pressure {
        public let increase: Increase

        public init(increase: Increase) {
            self.increase = increase
        }
    }
}

public extension Water.Pressure {
    struct Increase {
        public let value: Double
        public let unit: Depth.Unit

        public init(value: Double, unit: Depth.Unit) {
            self.value = value
            self.unit = unit
        }

        public init(_ value: Double, units: Units) {
            self.init(value: value, unit: units.depth)
        }
    }
}

extension Water.Pressure: Equatable {}
extension Water.Pressure.Increase: Equatable {}
