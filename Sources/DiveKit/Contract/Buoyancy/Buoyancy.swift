import Foundation

public enum Buoyancy {
    case positive(_ buoyantForce: Double)
    case negative(_ buoyantForce: Double)
    case neutral
}

extension Buoyancy: Equatable {}
extension Buoyancy: ResultRepresentable {}
