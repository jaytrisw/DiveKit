import Foundation

package struct Validator<Value> {
    package let validate: (Value) -> Bool

    package init(validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }
}

package extension Validator {
    func or(_ other: Validator) -> Self {
        .init {
            validate($0) || other.validate($0)
        }
    }
}
