import DiveKitInternals

public extension PhysicsCalculating {
    func airVolumeFromSurface(
        to depth: Double,
        with volume: Double) throws -> Calculation<Double.Result<Units.Pressure>> {
            try volume.validate(
                with: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.volume)))
                })
            .map { try atmospheresAbsolute(
                at: depth,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
                }) }
            .map { .double(volume / $0.result.value, unit: \.pressure, from: configuration) }
        }
}
