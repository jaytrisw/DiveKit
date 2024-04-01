import DiveKitCore

package extension Calculation {
    func with(_ other: () throws -> Calculation) rethrows -> CalculationTuple<Value, Unit> {
        .init(first: self, second: try other())
    }
}
