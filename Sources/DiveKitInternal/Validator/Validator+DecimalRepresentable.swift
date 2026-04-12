import Foundation

package extension Validator where Value: DecimalRepresentable {
    static var nonNegative: Self {
        .init { $0 >= .zero }
    }

    static func greater(than bound: Value) -> Self {
        .init { $0 > bound }
    }
}
