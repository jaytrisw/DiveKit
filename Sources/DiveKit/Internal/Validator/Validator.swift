import Foundation

internal struct Validator<Value> {
    internal let validate: (Value) -> Bool

    internal init(validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }
}

extension Validator {
    func or(_ other: Validator) -> Self {
        .init {
            validate($0) || other.validate($0)
        }
    }
}

extension Validator {
    func and(_ other: Validator) -> Self {
        .init {
            validate($0) && other.validate($0)
        }
    }
}
