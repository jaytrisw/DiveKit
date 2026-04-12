import Foundation

public struct Volume: Sendable, Equatable, Hashable, Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
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
