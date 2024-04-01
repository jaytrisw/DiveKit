import DiveKitCore

package extension CalculationDeprecated {
    func with(_ other: () throws -> CalculationDeprecated) rethrows -> CalculationTuple<Value, Unit> {
        .init(first: self, second: try other())
    }
}
