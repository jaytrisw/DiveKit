import Foundation

public extension PhysicsCalculating {
    func airVolumeToSurface(
        from depth: Depth,
        with volume: Volume) throws -> Calculation<Double.Result<Pressure.Unit>> {
            try volume.validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.volume)))
                })
            .map { _ in try atmospheresAbsolute(
                at: depth,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
                }) }
            .map { volume.value * $0.result.value }
            .map { .double($0, unit: \.pressure, from: configuration) }
        }
}
