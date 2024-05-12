import Foundation

public protocol DecimalUnitLocalizable {
    associatedtype Unit: UnitRepresentable, LocalizationProviding, Codable, Hashable, Equatable
    var value: Double { get }

    init(_ value: Double)
    func localization(for unit: Unit, style: LocalizationStyle) -> String
}

extension DecimalUnitLocalizable where Unit.Component: QuantityLocalizationComponent {
    public func localization(for unit: Unit, style: LocalizationStyle) -> String {
        unit.localization(for: .quantity(value, style))
    }
}
