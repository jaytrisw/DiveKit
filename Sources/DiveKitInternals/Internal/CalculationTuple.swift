import DiveKitCore

package struct CalculationTuple<Value, Unit: UnitRepresentable> {
    package let first: CalculationDeprecated<Value, Unit>
    package let second: CalculationDeprecated<Value, Unit>

    package init(first: CalculationDeprecated<Value, Unit>, second: CalculationDeprecated<Value, Unit>) {
        self.first = first
        self.second = second
    }
}

package struct Tuple<Value> {
    package let first: Value
    package let second: Value

    package init(first: Value, second: Value) {
        self.first = first
        self.second = second
    }
}
