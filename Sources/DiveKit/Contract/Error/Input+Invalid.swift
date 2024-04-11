import Foundation

public extension Error.Input {
    enum Invalid {
        case tank(_ tank: DiveKit.Tank)
    }
}

extension Error.Input.Invalid: Equatable {}
