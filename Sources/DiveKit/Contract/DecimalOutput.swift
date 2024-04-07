import Foundation

public struct DecimalOutput<Decimal: DecimalOutputRepresentable> {
    public let decimal: Decimal
    public let unit: Decimal.Unit

    package init(_ decimal: Decimal, unit: Decimal.Unit) {
        self.decimal = decimal
        self.unit = unit
    }
}

extension DecimalOutput: Equatable {}
extension DecimalOutput: ResultRepresentable {}
