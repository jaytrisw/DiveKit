import DiveKitInternals

public extension PhysicsCalculating {
    func airVolumeToSurface(
        from depth: Double,
        with volume: Double) throws -> Calculation<Double.Result<Units.Pressure>> {
            try volume.validate(
                with: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.volume)))
                })
            .map { _ in try atmospheresAbsolute(
                at: depth,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
                }) }
            .map { .double(volume * $0.result.value, unit: \.pressure, from: configuration) }
        }
}
