import Foundation

internal struct Tuple<Value, Other> {
    internal let first: Value
    internal let second: Other

    internal init(first: Value, second: Other) {
        self.first = first
        self.second = second
    }
}
