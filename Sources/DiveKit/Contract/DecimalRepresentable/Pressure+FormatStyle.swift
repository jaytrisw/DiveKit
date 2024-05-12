import Foundation

public extension FormatStyle where Self == DecimalUnitFormatStyle<Pressure> {
    static func pressure(_ unit: Pressure.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
