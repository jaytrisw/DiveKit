import Foundation

public extension Units {
    var weight: Weight {
        switch self {
            case .imperial: .pounds
            case .metric: .kilograms
        }
    }

    enum Weight: UnitRepresentable {
        case pounds
        case kilograms
    }
}
