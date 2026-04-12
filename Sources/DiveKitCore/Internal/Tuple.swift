import Foundation

package struct Tuple<Value, Other> {
    package let first: Value
    package let second: Other

    package init(first: Value, second: Other) {
        self.first = first
        self.second = second
    }
}
