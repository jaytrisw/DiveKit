import Foundation

public struct DecimalResult<Decimal: DecimalResultRepresentable>: Sendable {
    public var value: Double
    public let unit: Decimal.Unit

    package init(_ value: Double, unit: Decimal.Unit) {
        self.value = value
        self.unit = unit
    }
}

extension DecimalResult: Equatable {}
extension DecimalResult: ResultRepresentable {}
