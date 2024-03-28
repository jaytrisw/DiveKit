import Foundation

public extension Units {
    var volume: Volume {
        switch self {
            case .imperial: .cubicFeet
            case .metric: .liters
        }
    }

    enum Volume: UnitRepresentable {
        case liters
        case cubicFeet
    }
}
