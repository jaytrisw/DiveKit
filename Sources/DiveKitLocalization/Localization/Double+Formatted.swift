import Foundation
import DiveKitCore

public extension Double {
    /// Formats this raw value by constructing the format style's decimal input.
    ///
    /// - Parameter formatStyle: The format style to apply.
    /// - Returns: The formatted output produced by `formatStyle`.
    /// - Since: 1.0.0
    func formatted<Style: FormatStyle>(
        _ formatStyle: Style) -> Style.FormatOutput where Style.FormatInput: DecimalUnitLocalizable {
            formatStyle.format(.init(self))
        }
}
