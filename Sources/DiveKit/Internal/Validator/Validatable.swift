import Foundation

internal protocol Validatable {}

internal extension Validatable {
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
        onValidated perform: (Self) -> Void,
        orThrow error: () -> Error) throws {
            guard validator.validate(self) else {
                throw error()
            }
            perform(self)
        }
}

extension Double: Validatable {}
extension Depth: Validatable {}
