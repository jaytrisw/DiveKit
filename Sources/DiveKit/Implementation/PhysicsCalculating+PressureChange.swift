import DiveKitInternals

public extension PhysicsCalculating {
    func pressureChange(
        from firstDepth: Double,
        to secondDepth: Double) throws -> Calculation<DoubleResult<Units.Pressure>> {
            try atmospheresAbsolute(at: firstDepth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) })
                .with { try atmospheresAbsolute(at: secondDepth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) }) }
                .map { .init($0.second.result.value - $0.first.result.value, unit: \.pressure, from: configuration) }
        }
}
