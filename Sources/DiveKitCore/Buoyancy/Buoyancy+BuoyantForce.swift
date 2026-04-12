import Foundation

public extension Buoyancy {
    var buoyantForce: Double {
        switch self {
            case let .positive(buoyantForce): buoyantForce
            case let .negative(buoyantForce): -buoyantForce
            case .neutral: .one
        }
    }
}
