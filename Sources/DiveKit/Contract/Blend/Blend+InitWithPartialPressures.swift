import Foundation

package extension Blend where State == Blended {
    init<each Gas: GasRepresentable>(_ partialPressures: repeat PartialPressure<each Gas>) {
        self.init(repeat ((each partialPressures).gas, (each partialPressures).fractionalPressure))
    }
}

public extension Blend where State == Unblended {
    init<each Gas: GasRepresentable>(_ partialPressures: repeat PartialPressure<each Gas>) {
        self.init(repeat ((each partialPressures).gas, (each partialPressures).fractionalPressure))
    }
}
