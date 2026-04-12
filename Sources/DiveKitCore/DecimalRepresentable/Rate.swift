import Foundation

public struct Rate<Value: DecimalResultRepresentable>: Sendable, Equatable, Hashable
    where Value.Unit: Codable & Hashable {

    public let value: Double

    public init(_ value: Double) {
        self.value = value
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
