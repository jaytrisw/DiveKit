import Foundation

public struct Minutes {
    public let value: Double
}

extension Minutes: DecimalInputRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
