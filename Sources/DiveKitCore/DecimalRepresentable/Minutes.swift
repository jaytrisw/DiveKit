import Foundation

public struct Minutes: Sendable, Equatable, Hashable {
    public let value: Double

    public init(_ value: Double) {
        self.value = value
    }
}
