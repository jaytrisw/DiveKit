import Foundation

public protocol GasCalculating: ConfigurationProviding {
    func partialPressure<Gas: GasRepresentable>(
        of partialPressure: PartialPressure<Gas>,
        at depth: Double,
        using physicsCalculator: PhysicsCalculating) throws -> Calculation<PartialPressure<Gas>>
}
