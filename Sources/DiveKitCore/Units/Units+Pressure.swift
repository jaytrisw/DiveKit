import Foundation

public extension Units {
    var pressure: Pressure.Unit {
        switch self {
            case .imperial: .psi
            case .metric: .bar
        }
    }
}
