import Foundation

package struct DecimalOutput<Value: DecimalOutputRepresentable> {
    public let value: Value
    public let unit: Value.Unit

    package init(_ value: Value, unit: Value.Unit) {
        self.value = value
        self.unit = unit
    }
}

extension DecimalOutput: Equatable {}
extension DecimalOutput: ResultRepresentable {}
