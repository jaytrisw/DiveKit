import Foundation

public struct Rate<Value: DecimalUnitLocalizable>: Sendable where Value.Unit.Component == LocalizationComponent {
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

extension Rate: DecimalUnitLocalizable {
    public func localization(for unit: Unit, style: LocalizationStyle) -> String {
        unit.localization(for: .quantity(value, style))
    }
}

public enum RateUnit<BaseUnit: UnitRepresentable & LocalizationProviding & Codable & Hashable & Equatable>: UnitRepresentable, Sendable where BaseUnit.Component == LocalizationComponent {
    case perMinute(BaseUnit)
}

extension RateUnit: Codable {}
extension RateUnit: Hashable {}
extension RateUnit: Equatable {}
