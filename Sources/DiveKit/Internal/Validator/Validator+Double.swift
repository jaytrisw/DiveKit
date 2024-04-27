import Foundation

internal extension Validator where Value == Double {
    static func between(_ lower: Value, and upper: Value) -> Self {
        .init { $0 >= lower && $0 <= upper }
    }
}

internal extension Double {
    static var one: Self {
        1
    }
}
