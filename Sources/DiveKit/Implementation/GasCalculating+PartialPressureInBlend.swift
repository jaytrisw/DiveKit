import Foundation

public extension GasCalculating {
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        in blend: Blend<Blended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>> {
            try partialPressure(
                of: gas,
                in: blend,
                at: depth,
                using: physicsCalculator,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                })
        }
    
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        blending blend: Blend<Unblended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>> {
            try blend.blend(
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.blend(.totalPressure)))
                })
            .map { try partialPressure(
                of: gas,
                in: $0,
                at: depth,
                using: physicsCalculator,
                orThrow: {
                    error(describing: self, for: $0, with: .gasCalculator(.negative(.depth)))
                }) }
        }
}
