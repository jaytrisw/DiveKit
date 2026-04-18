import Foundation

public extension Units {
    /// The pressure unit associated with this unit system.
    ///
    /// - Returns: `.psi` for `.imperial`, or `.bar` for `.metric`.
    /// - Since: 1.0.0
    var pressure: Pressure.Unit {
        switch self {
            case .imperial: .psi
            case .metric: .bar
        }
    }
}
