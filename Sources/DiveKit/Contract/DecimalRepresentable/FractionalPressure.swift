import Foundation

public struct PartialPressure: Sendable {
    public let value: Double
}

extension PartialPressure: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}

extension PartialPressure: ResultRepresentable {}
