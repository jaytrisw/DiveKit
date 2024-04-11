import Foundation

internal extension Validator where Value == Object {
    static var nonNegative: Self {
        .init {
            $0.volume.validate(using: .nonNegative) &&
            $0.weight.validate(using: .nonNegative)
        }
    }
}
