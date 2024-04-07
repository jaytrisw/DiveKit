import Foundation

public enum Blended: BlendState {}

public extension Blend where State == Blended {
    func partialPressure<Gas: GasRepresentable>(of gas: Gas) -> PartialPressure<Gas> {
        .init(gas, fractionalPressure: storage[gas, default: .zero])
    }
}
