import Foundation

package protocol Validatable {}

package extension Validatable {
    func validate(using validator: Validator<Self>) -> Bool {
        validator.validate(self)
    }

    @discardableResult
    func validate(
        using validator: Validator<Self>,
        orThrow error: (Self) -> Error) throws -> Self {
            guard validator.validate(self) else {
                throw error(self)
            }
            return self
        }

    func validate(
        using validator: Validator<Self>,
        perform: (Self) -> Void,
        orThrow error: (Self) -> Error) throws {
            guard validator.validate(self) else {
                throw error(self)
            }
            perform(self)
        }
}

extension Double: Validatable {}
extension Depth: Validatable {}
extension Object: Validatable {}
extension Tank: Validatable {}
