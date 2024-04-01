import DiveKitCore

package struct Tuple<Value> {
    package let first: Value
    package let second: Value

    package init(first: Value, second: Value) {
        self.first = first
        self.second = second
    }
}
