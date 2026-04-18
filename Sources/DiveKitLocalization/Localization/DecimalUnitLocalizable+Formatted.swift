import Foundation
import DiveKitCore

public extension DecimalUnitLocalizable {
    /// Formats this value using a compatible format style.
    ///
    /// - Parameter formatStyle: The format style to apply.
    /// - Returns: The formatted output produced by `formatStyle`.
    /// - Since: 1.0.0
    func formatted<Style: FormatStyle>(
        _ formatStyle: Style) -> Style.FormatOutput where Style.FormatInput == Self {
            formatStyle.format(self)
        }
}
