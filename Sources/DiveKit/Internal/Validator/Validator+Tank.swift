import Foundation

internal extension Validator where Value == Tank {
    static var size: Self {
        .init {
            $0.size.ratedPressure.validate(using: .nonNegative) &&
            $0.size.volume.validate(using: .nonNegative)
        }
    }
}
