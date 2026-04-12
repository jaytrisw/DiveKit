import Foundation

public struct Rate<Value: DecimalResultRepresentable>: Sendable, Equatable, Hashable, Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral
    where Value.Unit: Codable & Hashable {

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

extension Rate: DecimalResultRepresentable {
    public typealias Unit = RateUnit<Value.Unit>
}

public enum RateUnit<BaseUnit: UnitRepresentable & Codable & Hashable & Equatable>: UnitRepresentable, Sendable {
    case perMinute(BaseUnit)
}

extension RateUnit: Codable {}
extension RateUnit: Hashable {}
extension RateUnit: Equatable {}
