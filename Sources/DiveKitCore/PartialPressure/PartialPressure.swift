import Foundation

public struct PartialPressure<Gas: GasRepresentable>: Sendable, Equatable, Hashable {
    public let value: Double

    public var unit: Pressure.Unit {
        .atmospheres
    }

    public init(_ value: Double) {
        self.value = value
    }
}

extension PartialPressure: ResultRepresentable {}
