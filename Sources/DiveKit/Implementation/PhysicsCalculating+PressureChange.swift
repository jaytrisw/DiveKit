import DiveKitInternals

public extension PhysicsCalculating {
    func pressureChange(
        from firstDepth: Double,
        to secondDepth: Double) throws -> CalculationDeprecated<Double, Units.Pressure> {
            try atmospheresAbsolute(at: firstDepth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) })
                .with { try atmospheresAbsolute(at: secondDepth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) }) }
                .map { .init($0.second.value - $0.first.value, unit: \.pressure, from: configuration) }
        }
}
