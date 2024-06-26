import Foundation

public struct Depth {
    public let value: Double
}

extension Depth: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Depth {
    enum Unit: UnitRepresentable {
        case feet
        case meters
    }
}

extension Depth: DecimalResultRepresentable {}
extension Depth: DecimalUnitLocalizable {}
extension Depth.Unit: Codable {}
extension Depth.Unit: Hashable {}
extension Depth.Unit: Equatable {}
