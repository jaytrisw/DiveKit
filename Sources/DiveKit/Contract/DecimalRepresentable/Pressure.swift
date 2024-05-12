import Foundation

public struct Pressure {
    public let value: Double
}

extension Pressure: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Pressure {
    enum Unit: UnitRepresentable {
        case psi
        case bar
        case atmospheres
    }
}

extension Pressure: DecimalResultRepresentable {}
extension Pressure: DecimalUnitLocalizable {}
extension Pressure.Unit: Codable {}
extension Pressure.Unit: Hashable {}
extension Pressure.Unit: Equatable {}
