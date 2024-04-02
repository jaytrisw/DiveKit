import Foundation

package protocol Validatable {}

package extension Validatable {
    func validate(using validator: Validator<Self>) -> Bool {
        validator.validate(self)
    }

    @discardableResult
    func validate<E: Swift.Error>(
        using validator: Validator<Self>,
        orThrow error: (Self) -> E) throws -> Self {
            guard validator.validate(self) else {
                throw error(self)
            }
            return self
        }

    func validate<E: Swift.Error>(
        using validator: Validator<Self>,
        perform: (Self) -> Void,
        orThrow error: (Self) -> E) throws {
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
        otherThrow otherError: (Self) -> E2) throws -> Tuple<Self> {
            try validate(using: validator, orThrow: error)
            try other.validate(using: validator, orThrow: otherError)

            return .init(first: self, second: other)
        }
}

extension Double: Validatable {}
extension Tank: Validatable {}
