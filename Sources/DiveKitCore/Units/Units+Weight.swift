import Foundation

public extension Units {
    var mass: Mass.Unit {
        switch self {
            case .imperial: .pounds
            case .metric: .kilograms
        }
    }
}
