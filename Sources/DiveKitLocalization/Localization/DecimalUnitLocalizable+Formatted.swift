import Foundation
import DiveKitCore

public extension DecimalUnitLocalizable {
    func formatted<Style: FormatStyle>(
        _ formatStyle: Style) -> Style.FormatOutput where Style.FormatInput == Self {
            formatStyle.format(self)
        }
}
