import Foundation

public extension Units {
    /// The mass unit associated with this unit system.
    ///
    /// - Returns: `.pounds` for `.imperial`, or `.kilograms` for `.metric`.
    /// - Since: 1.0.0
    var mass: Mass.Unit {
        switch self {
            case .imperial: .pounds
            case .metric: .kilograms
        }
    }
}
