import Foundation

package typealias ExpressibleBy = ExpressibleByFloatLiteral & ExpressibleByIntegerLiteral

package protocol DecimalInputRepresentable: Equatable, Hashable, Comparable, ExpressibleBy, Validatable, Mappable {
    var value: Double { get }

    init(_ value: Double)
}

extension DecimalInputRepresentable {

    // MARK: ExpressibleByFloatLiteral

    public init(floatLiteral value: Float) {
        self.init(.init(value))
    }

    // MARK: ExpressibleByIntegerLiteral

    public init(integerLiteral value: Int) {
        self.init(.init(value))
    }

    // MARK: Comparable

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }

    // MARK: Zero

    public static var zero: Self {
        .init(.zero)
    }
}
