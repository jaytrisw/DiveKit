import Foundation

public struct Mass: Sendable, Equatable, Hashable, Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public let value: Double

    public init(_ value: Double) {
        self.value = value
    }

    public init(floatLiteral value: Float) {
        self.init(.init(value))
    }

    public init(integerLiteral value: Int) {
        self.init(.init(value))
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }

    public static var zero: Self {
        .init(.zero)
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
