import Foundation

public extension Units {
    /// The depth unit associated with this unit system.
    ///
    /// - Returns: `.feet` for `.imperial`, or `.meters` for `.metric`.
    /// - Since: 1.0.0
    var depth: Depth.Unit {
        switch self {
            case .imperial: .feet
            case .metric: .meters
        }
    }
}
