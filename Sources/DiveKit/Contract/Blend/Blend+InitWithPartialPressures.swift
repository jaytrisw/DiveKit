import Foundation

package extension Blend where State == Blended {
    init<each Gas: GasRepresentable>(_ partialPressures: repeat PartialPressure<each Gas>) {
        self.init(repeat ((each partialPressures).gas, (each partialPressures).value))
    }
}

public extension Blend where State == Unblended {
    init<each Gas: GasRepresentable>(_ partialPressures: repeat PartialPressure<each Gas>) {
        self.init(repeat ((each partialPressures).gas, (each partialPressures).value))
    }
}

private extension Blend {
    init<each Gas: GasRepresentable>(_ tuples:  repeat ((each Gas), Double)) {
        func insert<G: GasRepresentable>(_ input: (G, Double), into dictionary: inout Dictionary<AnyHashable, Double>) {
            dictionary.updateValue(input.1, forKey: input.0)
        }
        var dictionary: Dictionary<AnyHashable, Double> = .init()

        repeat insert(((each tuples).0, (each tuples).1), into: &dictionary)

        self.init(storage: dictionary)
    }
}
