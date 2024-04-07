import Foundation

public extension PhysicsCalculating {
    func atmospheresAbsolute(at depth: Depth) throws -> Calculation<DecimalOutput<Pressure>> {
        try atmospheresAbsolute(
            at: depth,
            orThrow: {
                error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
            })
    }
}
