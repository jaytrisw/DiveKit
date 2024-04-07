import Foundation

package extension Validator where Value == Double {
    static func between(_ lower: Value, and upper: Value) -> Self {
        .init(validate: { $0 >= lower && $0 <= upper })
    }
}

package extension Double {
    static var one: Self {
        1
    }
}

package extension Validator where Value: DecimalRepresentable {
    static var nonNegative: Self {
        .init(validate: { $0 >= .zero })
    }
}
