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
        self.init(storage: .init(repeat ((each values).0, (each values).1)))
    }
}

extension Dictionary {
    mutating func update(_ keyValue: (key: Key, value: Value)) {
        updateValue(keyValue.value, forKey: keyValue.key)
    }

    init<each H: Hashable>(_ values: repeat ((each H), Value)) where Key == AnyHashable {
        var dictionary: Self = .init()

        repeat dictionary.update(((each values).0, (each values).1))

        self.init(uniqueKeysWithValues: dictionary.compactMap { key, value in
            return (key, value)
        })

    }
}
