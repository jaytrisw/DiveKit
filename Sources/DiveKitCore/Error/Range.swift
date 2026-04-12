import Foundation

public extension Error {
    enum Range: Sendable {
        case lowerBound(_ provided: Double, _ expected: Double)
        case upperBound(_ provided: Double, _ expected: Double)
    }
}

extension Error.Range: Equatable {}
