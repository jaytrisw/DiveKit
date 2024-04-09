import Foundation

public extension Error.Input {
    enum Invalid {
        case object(_ object: Object)
        case blend(_ blend: Blend<Unblended>)
        case tank(_ tank: Tank)
    }
}

extension Error.Input.Invalid: Equatable {}
