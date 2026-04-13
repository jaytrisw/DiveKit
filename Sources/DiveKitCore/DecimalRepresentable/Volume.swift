import Foundation

public struct Volume: Sendable, Equatable, Hashable {
    public let value: Double

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
extension Volume.Unit: Codable {}
extension Volume.Unit: Hashable {}
extension Volume.Unit: Equatable {}
