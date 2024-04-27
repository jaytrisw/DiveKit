import Foundation

public extension Units {
    var volume: Volume.Unit {
        switch self {
            case .imperial: .cubicFeet
            case .metric: .liters
        }
    }
}
