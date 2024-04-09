import Foundation

internal struct Validator<Value> {
    internal let validate: (Value) -> Bool

    internal init(validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }
}
