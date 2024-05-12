import Foundation

public extension FormatStyle where Self == DecimalUnitFormatStyle<Depth> {
    static func depth(_ unit: Depth.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
