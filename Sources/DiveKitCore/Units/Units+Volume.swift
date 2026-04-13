import Foundation

public extension Units {
    /// The volume unit associated with this unit system.
    ///
    /// - Returns: `.cubicFeet` for `.imperial`, or `.liters` for `.metric`.
    /// - Since: 1.0.0
    var volume: Volume.Unit {
        switch self {
            case .imperial: .cubicFeet
            case .metric: .liters
        }
    }
}
