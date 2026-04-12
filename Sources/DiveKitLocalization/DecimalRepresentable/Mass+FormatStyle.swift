import Foundation
import DiveKitCore

public extension FormatStyle where Self == DecimalUnitFormatStyle<Mass> {
    static func mass(_ unit: Mass.Unit, style: LocalizationStyle) -> Self {
        .init(unit, style: style)
    }
}
