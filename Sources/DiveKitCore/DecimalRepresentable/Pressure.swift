import Foundation

public struct Pressure: Sendable, Equatable, Hashable, Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
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

public extension Pressure {
    enum Unit: UnitRepresentable {
        case psi
        case bar
        case atmospheres
    }
}

extension Pressure: DecimalResultRepresentable {}
extension Pressure.Unit: Codable {}
extension Pressure.Unit: Hashable {}
extension Pressure.Unit: Equatable {}
