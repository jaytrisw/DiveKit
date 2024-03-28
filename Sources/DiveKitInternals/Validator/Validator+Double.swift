import Foundation

package extension Validator where Value == Double {
    static var nonNegative: Self {
        .init(validate: { $0 >= .zero })
    }
}

package extension Double {
    @discardableResult
    func validate<E: Swift.Error>(_ validator: Validator<Double>, orThrow error: () -> E) throws -> Self {
        guard validator.validate(self) else {
            throw error()
        }
        return self
    }

    func map<Transform>(_ transform: (Self) throws -> Transform) rethrows -> Transform {
        try transform(self)
    }
}
