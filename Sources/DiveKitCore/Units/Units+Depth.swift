import Foundation

public extension Units {
    var depth: Depth.Unit {
        switch self {
            case .imperial: .feet
            case .metric: .meters
        }
    }
}
