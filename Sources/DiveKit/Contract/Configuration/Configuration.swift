import Foundation

public struct Configuration {
    public let units: Units
    public let water: Water

    public init(units: Units, water: Water) {
        self.units = units
        self.water = water
    }
}

extension Configuration: Equatable {
    public static func == (lhs: Configuration, rhs: Configuration) -> Bool {
        rhs.units == lhs.units &&
        rhs.water.weight(rhs.units) == lhs.water.weight(rhs.units) &&
        rhs.water.pressure(rhs.units) == lhs.water.pressure(rhs.units)
    }
}
