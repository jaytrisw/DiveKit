import Foundation
import DiveKitCore

package extension Blend where State == Blended {
    init<each Gas: GasRepresentable>(_ fractionalPressures: repeat FractionalPressure<each Gas>) {
        self.init(repeat ((each fractionalPressures).gas, (each fractionalPressures).value))
    }
}

public extension Blend where State == Unblended {
    init<each Gas: GasRepresentable>(_ fractionalPressures: repeat FractionalPressure<each Gas>) {
        self.init(repeat ((each fractionalPressures).gas, (each fractionalPressures).value))
    }
}
