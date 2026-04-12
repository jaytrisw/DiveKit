import Foundation
import DiveKitCore

extension Depth: DecimalUnitLocalizable {}
extension Mass: DecimalUnitLocalizable {}
extension Pressure: DecimalUnitLocalizable {}
extension Volume: DecimalUnitLocalizable {}

extension Rate: DecimalUnitLocalizable
    where
    Value: DecimalUnitLocalizable,
    Value.Unit.Component == LocalizationComponent {

    public func localization(for unit: Unit, style: LocalizationStyle) -> String {
        unit.localization(for: .quantity(value, style))
    }
}
