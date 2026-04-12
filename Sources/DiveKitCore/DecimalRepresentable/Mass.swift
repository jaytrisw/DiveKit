import Foundation

public struct Mass: Sendable, Equatable, Hashable {
    public let value: Double

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
extension Mass.Unit: Codable {}
extension Mass.Unit: Hashable {}
extension Mass.Unit: Equatable {}
