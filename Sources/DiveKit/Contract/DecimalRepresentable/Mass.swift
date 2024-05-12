import Foundation

public struct Mass {
    public let value: Double
}

extension Mass: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}

public extension Mass {
    enum Unit: UnitRepresentable {
        case pounds
        case kilograms
    }
}

extension Mass: DecimalResultRepresentable {}
extension Mass: DecimalUnitLocalizable {}
extension Mass.Unit: Codable {}
extension Mass.Unit: Hashable {}
extension Mass.Unit: Equatable {}
