import Foundation
import DiveKitCore

package protocol Validatable {}

package extension Validatable {
    @discardableResult
    func validate(
        using validator: Validator<Self>,
        orThrow error: (Self) -> Error) throws(Error) -> Self {
            guard validator.validate(self) else {
                throw error(self)
            }
            return self
        }
}

extension Double: Validatable {}
extension Depth: Validatable {}
