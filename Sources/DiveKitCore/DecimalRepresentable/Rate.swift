import Foundation

public struct Rate<Value: DecimalResultRepresentable>: Sendable
    where Value.Unit: Codable & Hashable {

    public let value: Double
}

extension Rate: DecimalRepresentable {
    public init(_ value: Double) {
        self.value = value
    }
}

extension Rate: Equatable {}

extension Rate: DecimalResultRepresentable {
    public typealias Unit = RateUnit<Value.Unit>
}

public enum RateUnit<BaseUnit: UnitRepresentable & Codable & Hashable & Equatable>: UnitRepresentable, Sendable {
    case perMinute(BaseUnit)
}

extension RateUnit: Codable {}
extension RateUnit: Hashable {}
extension RateUnit: Equatable {}
