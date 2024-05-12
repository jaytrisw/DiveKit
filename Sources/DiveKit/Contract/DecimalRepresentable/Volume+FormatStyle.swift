import Foundation

public extension FormatStyle where Self == DecimalUnitFormatStyle<Volume> {
    static func volume(_ unit: Volume.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
