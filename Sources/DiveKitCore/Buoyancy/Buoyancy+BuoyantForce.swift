import Foundation

public extension Buoyancy {
    /// The signed buoyant force.
    ///
    /// Positive buoyancy returns a positive value, negative buoyancy returns a
    /// negative value, and neutral buoyancy returns `0`.
    ///
    /// - Since: 1.0.0
    var buoyantForce: Double {
        switch self {
            case let .positive(buoyantForce): buoyantForce
            case let .negative(buoyantForce): -buoyantForce
            case .neutral: 0
        }
    }
}
