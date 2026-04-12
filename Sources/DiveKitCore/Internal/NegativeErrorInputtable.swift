import Foundation

package extension Error {
    static func negative<E: NegativeErrorInputtable>(_ value: E, _ callSite: CallSite) -> Self {
        .negative(value.negativeInput(), callSite)
    }
}

package protocol NegativeErrorInputtable {
    func negativeInput() -> Error.Negative
}

extension Depth: NegativeErrorInputtable {
    package func negativeInput() -> Error.Negative {
        .depth(self)
    }
}
extension Volume: NegativeErrorInputtable {
    package func negativeInput() -> Error.Negative {
        .volume(self)
    }
}
extension Mass: NegativeErrorInputtable {
    package func negativeInput() -> Error.Negative {
        .weight(self)
    }
}
extension Pressure: NegativeErrorInputtable {
    package func negativeInput() -> Error.Negative {
        .pressure(self)
    }
}
extension FractionalPressure: NegativeErrorInputtable {
    package func negativeInput() -> Error.Negative {
        .fractionalPressure(value)
    }
}
extension PartialPressure: NegativeErrorInputtable {
    package func negativeInput() -> Error.Negative {
        .partialPressure(value)
    }
}
extension Minutes: NegativeErrorInputtable {
    package func negativeInput() -> Error.Negative {
        .minutes(self)
    }
}
