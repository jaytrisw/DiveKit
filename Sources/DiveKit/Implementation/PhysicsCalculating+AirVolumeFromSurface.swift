import Foundation

public extension PhysicsCalculating {
    func airVolumeFromSurface(
        to depth: Depth,
        with volume: Volume) throws -> Calculation<DecimalResult<Pressure>> {
            try volume.validate(
                using: .nonNegative,
                orThrow: { .input(.negative(.volume($0)), .from(self)) })
            .map { try atmospheresAbsolute(at: depth, .from(self)) }
            .map { volume.value / $0.result.value }
            .map { .decimal($0, unit: \.pressure, from: configuration) }
        }
}
