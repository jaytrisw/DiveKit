import Foundation

internal extension Validator where Value == Double {
    static func between(_ lower: Value, and upper: Value) -> Self {
        .init(validate: { $0 >= lower && $0 <= upper })
    }
}

internal extension Double {
    static var one: Self {
        1
    }
}

internal extension Validator where Value: DecimalRepresentable {
    static var nonNegative: Self {
        .init(validate: { $0 >= .zero })
    }
}
