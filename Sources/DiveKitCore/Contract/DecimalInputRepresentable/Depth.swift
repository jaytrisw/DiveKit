import Foundation

public struct Depth {
    public let value: Double
}

extension Depth: DecimalInputRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
