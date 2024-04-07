import Foundation

public struct FractionalPressure {
    public let value: Double
}

extension FractionalPressure: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
