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

internal extension Blend {
    init<each Gas: GasRepresentable>(_ values:  repeat ((each Gas), Double)) {
        var storage: [AnyGas: Double] = [:]
        repeat _ = storage.updateValue((each values).1, forKey: .init((each values).0))
        self.init(storage: storage)
    }
}
