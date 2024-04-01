import Foundation

public extension Double {
    struct Result<Unit: UnitRepresentable> {
        public let value: Double
        public let unit: Unit

        package init(_ value: Double, unit: Unit) {
            self.value = value
            self.unit = unit
        }
    }
}

extension Double.Result: Equatable {}
extension Double.Result: ResultRepresentable {}
