import Foundation

public extension PhysicsCalculating {
    func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws -> Calculation<DecimalResult<Pressure>> {
            try atmospheresAbsolute(at: firstDepth, from: .from(self))
                .with { try atmospheresAbsolute(at: secondDepth, from: .from(self)) }
                .map { $0.second.result.value - $0.first.result.value }
                .map { .decimal($0, unit: \.pressure, from: configuration) }
        }
}
