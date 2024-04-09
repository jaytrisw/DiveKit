import Foundation

public extension PhysicsCalculating {
    func atmospheresAbsolute(at depth: Depth) throws -> Calculation<DecimalResult<Pressure>> {
        try atmospheresAbsolute(at: depth, from: .from(self))
    }
}
