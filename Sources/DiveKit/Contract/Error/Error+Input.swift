import Foundation

public extension Error {
    enum Input {
        case negative(_ negative: Negative)
        case invalid(_ invalid: Invalid)
        case blend(_ blend: Blend)
    }
}

extension Error.Input: Equatable {}
