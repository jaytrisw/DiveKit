import Foundation

public extension FormatStyle {
    static func rate<Value>(
        _ unit: Rate<Value>.Unit,
        style: LocalizationStyle) -> Self
        where
        Self == DecimalUnitFormatStyle<Rate<Value>>,
        Value: DecimalUnitLocalizable,
        Value.Unit.Component == LocalizationComponent {
            .init(unit, style: style)
        }
}
