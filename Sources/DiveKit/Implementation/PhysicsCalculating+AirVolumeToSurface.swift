import DiveKitInternals

public extension PhysicsCalculating {
    func airVolumeToSurface(
        from depth: Double,
        with volume: Double) throws -> Calculation<Double, Units.Pressure> {
            try volume.validate(.nonNegative, orThrow: { error(describing: self, for: volume, with: .physicsCalculator(.negativeVolume)) })
                .map { _ in try atmospheresAbsolute(at: depth, orThrow: { error(describing: self, for: $0, with: .physicsCalculator(.negativeDepth)) }) }
                .map { .init(volume * $0.value, unit: \.pressure, from: configuration) }
        }
}
