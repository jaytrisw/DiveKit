import Foundation

public extension PhysicsCalculating {
    func airVolumeFromSurface(
        to depth: Depth,
        with volume: Volume) throws -> Calculation<DecimalOutput<Pressure>> {
            try volume.validate(
                using: .nonNegative,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.volume)))
                })
            .map { try atmospheresAbsolute(
                at: depth,
                orThrow: {
                    error(describing: self, for: $0, with: .physicsCalculator(.negative(.depth)))
                }) }
            .map { volume.value / $0.result.decimal.value }
            .map { .decimal(.init($0), unit: \.pressure, from: configuration) }
        }
}
