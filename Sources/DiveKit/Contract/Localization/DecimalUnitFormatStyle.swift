import Foundation

public struct DecimalUnitFormatStyle<Decimal: DecimalUnitLocalizable> {
    let unit: Decimal.Unit
    let style: LocalizationStyle

    public init(_ unit: Decimal.Unit, style: LocalizationStyle) {
        self.unit = unit
        self.style = style
    }
}

extension DecimalUnitFormatStyle: FormatStyle {
    public func format(_ value: Decimal) -> String {
        value.localization(for: unit, style: style)
    }
}
