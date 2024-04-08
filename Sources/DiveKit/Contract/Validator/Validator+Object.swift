import Foundation

package extension Validator where Value == Object {
    static var nonNegative: Self {
        .init(validate: {
            $0.volume.validate(using: .nonNegative) &&
            $0.weight.validate(using: .nonNegative)
        })
    }
}
