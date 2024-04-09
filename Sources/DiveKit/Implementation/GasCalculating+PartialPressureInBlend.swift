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
                from: .from(self))
        }
    
    func partialPressure<Gas: GasRepresentable>(
        of gas: Gas,
        blending blend: Blend<Unblended>,
        at depth: Depth,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>> {
            try blend.blend(from: .from(self))
                .map { try partialPressure(
                    of: gas,
                    in: $0,
                    at: depth,
                    using: physicsCalculator,
                    from: .from(self)) }
        }
}
