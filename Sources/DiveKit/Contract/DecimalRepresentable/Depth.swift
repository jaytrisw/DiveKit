import Foundation

public struct Depth {
    public let value: Double
}

extension Depth: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
