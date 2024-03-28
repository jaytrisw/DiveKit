import Foundation

public extension Units {
    var depth: Depth {
        switch self {
            case .imperial: .feet
            case .metric: .meters
        }
    }


    enum Depth: UnitRepresentable {
        case feet
        case meters
    }
}
