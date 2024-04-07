import Foundation

public struct Volume {
    public let value: Double
}

extension Volume: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}
