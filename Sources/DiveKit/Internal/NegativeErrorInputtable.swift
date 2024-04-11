import Foundation

internal extension Error {
    static func negative<E: NegativeErrorInputtable>(_ value: E, _ callSite: CallSite) -> Self {
        .negative(value.negativeInput(), callSite)
    }
}

internal protocol NegativeErrorInputtable {
    func negativeInput() -> Error.Negative
}

extension Depth: NegativeErrorInputtable {
    func negativeInput() -> Error.Negative {
        .depth(self)
    }
}
extension Volume: NegativeErrorInputtable {
    func negativeInput() -> Error.Negative {
        .volume(self)
    }
}
extension Mass: NegativeErrorInputtable {
    func negativeInput() -> Error.Negative {
        .weight(self)
    }
}
extension Pressure: NegativeErrorInputtable {
    func negativeInput() -> Error.Negative {
        .pressure(self)
    }
}
extension FractionalPressure: NegativeErrorInputtable {
    func negativeInput() -> Error.Negative {
        .fractionalPressure(self)
    }
}
extension Minutes: NegativeErrorInputtable {
    func negativeInput() -> Error.Negative {
        .minutes(self)
    }
}
