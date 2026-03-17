import Foundation

public struct FractionalPressure: Sendable {
    public let value: Double
}

extension FractionalPressure: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
