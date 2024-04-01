import DiveKitInternals

public extension PhysicsCalculating {
    func airVolumeFromSurface(
        to depth: Double,
        with volume: Double) throws -> Calculation<DoubleResult<Units.Pressure>> {
            try volume.validate(with: .nonNegative, orThrow: {
                error(describing: self, for: $0, with: .physicsCalculator(.negativeVolume))
            })
            .map { try atmospheresAbsolute(at: depth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) }) }
            .map { .init(volume / $0.result.value, unit: \.pressure, from: configuration) }
        }
}
