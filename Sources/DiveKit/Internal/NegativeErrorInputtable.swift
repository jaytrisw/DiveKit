import Foundation

internal extension Error {
    static func negative<E: NegativeErrorInputtable>(_ value: E, _ callSite: CallSite) -> Self {
        .input(.negative(value.negativeInput()), callSite)
    }
}

internal protocol NegativeErrorInputtable {
    func negativeInput() -> Error.Input.Negative
}

extension Depth: NegativeErrorInputtable {
    func negativeInput() -> Error.Input.Negative {
        .depth(self)
    }
}
extension Volume: NegativeErrorInputtable {
    func negativeInput() -> Error.Input.Negative {
        .volume(self)
    }
}
extension Mass: NegativeErrorInputtable {
    func negativeInput() -> Error.Input.Negative {
        .weight(self)
    }
}
extension Pressure: NegativeErrorInputtable {
    func negativeInput() -> Error.Input.Negative {
        .pressure(self)
    }
}
extension FractionalPressure: NegativeErrorInputtable {
    func negativeInput() -> Error.Input.Negative {
        .fractionalPressure(self)
    }
}
extension Minutes: NegativeErrorInputtable {
    func negativeInput() -> Error.Input.Negative {
        .minutes(self)
    }
}
