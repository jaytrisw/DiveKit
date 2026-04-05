import Foundation

package extension Blend where State == Blended {
    init<each Gas: GasRepresentable>(_ fractionalPressures: repeat FractionalPressure<each Gas>) {
        self.init(repeat ((each fractionalPressures).gas, (each fractionalPressures).fractionalPressure))
    }
}

public extension Blend where State == Unblended {
    init<each Gas: GasRepresentable>(_ fractionalPressures: repeat FractionalPressure<each Gas>) {
        self.init(repeat ((each fractionalPressures).gas, (each fractionalPressures).fractionalPressure))
    }
}
