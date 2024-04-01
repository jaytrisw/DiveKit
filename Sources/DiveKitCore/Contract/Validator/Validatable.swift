import Foundation

package protocol Validatable {}

package extension Validatable {
    @discardableResult
    func validate<E: Swift.Error>(with validator: Validator<Self>, orThrow error: (Self) -> E) throws -> Self {
        guard validator.validate(self) else {
            throw error(self)
        }
        return self
    }

    func validate<E: Swift.Error>(with validator: Validator<Self>, perform: (Self) -> Void, orThrow error: (Self) -> E) throws {
        guard validator.validate(self) else {
            throw error(self)
        }
        perform(self)
    }

    @discardableResult
    func validate<E1: Swift.Error, E2: Swift.Error>(
        with other: Self,
        using validator: Validator<Self>,
        orThrow error: (Self) -> E1,
        otherThrow otherError: (Self) -> E2) throws -> ValidatedTuple<Self> {
            try validate(with: validator, orThrow: error)
            try other.validate(with: validator, orThrow: otherError)

            return .init(first: self, second: other)
        }
}

package struct ValidatedTuple<Value> {
    package let first: Value
    package let second: Value
}

extension Double: Validatable {}
