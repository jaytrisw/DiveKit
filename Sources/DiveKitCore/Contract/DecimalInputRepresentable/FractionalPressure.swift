import Foundation

public struct FractionalPressure {
    public let value: Double
}

extension FractionalPressure: DecimalInputRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
