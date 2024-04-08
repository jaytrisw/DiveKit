import Foundation

public enum Buoyancy {
    case positive(_ buoyantForce: Double)
    case negative(_ buoyantForce: Double)
    case neutral

    package init(_ value: Double) {
        if value == 0 {
            self = .neutral
            return
        }
        if value < 0 {
            self = .negative(abs(value))
            return
        }
        self = .positive(value)
    }
}

extension Buoyancy: Equatable {}
extension Buoyancy: ResultRepresentable {}
