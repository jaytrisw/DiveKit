import Foundation

public extension Units {
    var pressure: Pressure {
        switch self {
            case .imperial: .psi
            case .metric: .bar
        }
    }

    enum Pressure: UnitRepresentable {
        case psi
        case bar
        case atmospheres
    }
}
