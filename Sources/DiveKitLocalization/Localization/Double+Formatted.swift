import Foundation
import DiveKitCore

public extension Double {
    func formatted<Style: FormatStyle>(
        _ formatStyle: Style) -> Style.FormatOutput where Style.FormatInput: DecimalUnitLocalizable {
            formatStyle.format(.init(self))
        }
}
