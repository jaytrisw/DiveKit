import DiveKitCore

package struct CalculationTuple<Value, Unit: UnitRepresentable> {
    package let first: Calculation<Value, Unit>
    package let second: Calculation<Value, Unit>

    package init(first: Calculation<Value, Unit>, second: Calculation<Value, Unit>) {
        self.first = first
        self.second = second
    }
}
