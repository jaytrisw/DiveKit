import DiveKitCore

package extension CalculationDeprecated {
    func with(_ other: () throws -> CalculationDeprecated) rethrows -> CalculationTuple<Value, Unit> {
        .init(first: self, second: try other())
    }
}

package extension Calculation {
    func with(_ other: () throws -> Calculation) rethrows -> Tuple<Self> {
        .init(first: self, second: try other())
    }
}

extension Tuple: Mappable {}
