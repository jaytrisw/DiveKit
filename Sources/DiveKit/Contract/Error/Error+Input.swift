import Foundation

public extension Error {
    enum Input {
        case negative(_ negative: Negative)
        case invalid(_ invalid: Invalid)
    }
}

extension Error.Input: Equatable {}
