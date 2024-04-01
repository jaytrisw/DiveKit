import DiveKitInternals

public extension PhysicsCalculating {
    func atmospheresAbsolute(at depth: Double) throws -> CalculationDeprecated<Double, Units.Pressure> {
        try atmospheresAbsolute(at: depth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) })
    }
}
