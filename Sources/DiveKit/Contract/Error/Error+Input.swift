import Foundation

public extension Error {
    enum Input {
        case negative(_ negative: Negative)
        case tank(_ tank: Tank)
        case blend(_ blend: Blend)
    }
}

extension Error.Input: Equatable {}
