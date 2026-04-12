import Foundation

public struct PartialPressure<Gas: GasRepresentable>: Sendable, Equatable, Hashable, Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public let value: Double

    public var unit: Pressure.Unit {
        .atmospheres
    }

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

extension PartialPressure: ResultRepresentable {}
