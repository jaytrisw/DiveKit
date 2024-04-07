import Foundation

public extension PhysicsCalculating {
    func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws -> Calculation<DecimalOutput<Pressure>> {
            try atmospheresAbsolute(
                at: firstDepth,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
                })
            .with { try atmospheresAbsolute(
                at: secondDepth,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
                }) }
            .map { $0.second.result.decimal.value - $0.first.result.decimal.value }
            .map { .decimal(.init($0), unit: \.pressure, from: configuration) }
        }
}
