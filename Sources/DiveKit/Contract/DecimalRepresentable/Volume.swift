import Foundation

public struct Volume {
    public let value: Double
}

extension Volume: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Volume {
    enum Unit: UnitRepresentable {
        case liters
        case cubicFeet
    }
}

extension Volume: DecimalResultRepresentable {}
