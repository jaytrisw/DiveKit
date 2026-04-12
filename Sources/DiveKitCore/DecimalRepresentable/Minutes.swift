import Foundation

public struct Minutes: Sendable {
    public let value: Double
}

extension Minutes: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
