import Foundation

internal struct Tuple<Value> {
    internal let first: Value
    internal let second: Value

    internal init(first: Value, second: Value) {
        self.first = first
        self.second = second
    }
}
