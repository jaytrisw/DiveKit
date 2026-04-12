import Foundation

public struct Depth: Sendable, Equatable, Hashable, Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
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

public extension Depth {
    enum Unit: UnitRepresentable {
        case feet
        case meters
    }
}

extension Depth: DecimalResultRepresentable {}
extension Depth.Unit: Codable {}
extension Depth.Unit: Hashable {}
extension Depth.Unit: Equatable {}
