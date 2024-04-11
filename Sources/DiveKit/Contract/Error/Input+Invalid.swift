import Foundation

public extension Error.Input {
    enum Invalid {
        case object(_ object: DiveKit.Object)
        case tank(_ tank: DiveKit.Tank)
    }
}

extension Error.Input.Invalid: Equatable {}
