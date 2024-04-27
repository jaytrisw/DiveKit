import Foundation

public struct Minutes {
    public let value: Double
}

extension Minutes: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
