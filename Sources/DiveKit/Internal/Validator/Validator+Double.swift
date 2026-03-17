import Foundation

internal extension Validator where Value == Double {
    static func between(_ lower: Value, and upper: Value) -> Self {
        .init { $0 >= lower && $0 <= upper }
    }

    static func greater(than bound: Value) -> Self {
        .init { $0 > bound }
    }

    static func less(than bound: Value) -> Self {
        .init { $0 < bound }
    }

    static func equal(to other: Value) -> Self {
        .init { $0 == other }
    }
}

internal extension Validator where Value == Double {
    static func greaterThanOrEqual(to bound: Value) -> Self {
        .greater(than: bound).or(.equal(to: bound))
    }

    static func lessThanOrEqual(to bound: Value) -> Self {
        .less(than: bound).or(.equal(to: bound))
    }
}

internal extension Double {
    static let one: Self = 1
}
