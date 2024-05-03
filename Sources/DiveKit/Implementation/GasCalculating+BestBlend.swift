import Foundation

public extension GasCalculating {
    func bestBlend(
        for depth: Depth,
        fractionOxygen: FractionalPressure,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<Blend<Blended>> {
            try fractionOxygen.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { try physicsCalculator.atmospheresAbsolute(at: depth, with: configuration, .from(self)) }
                .map { fractionOxygen.value / $0.result.value }
                .map { $0 * 100 }
                .map { $0.rounded(.towardZero) }
                .map { $0 / 100 }
                .map { .blend(.enrichedAir($0), configuration: configuration) }
        }
}
