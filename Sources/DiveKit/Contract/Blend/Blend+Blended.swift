import Foundation

public enum Blended: BlendState {}

public extension Blend where State == Blended {
    func partialPressure<Gas: GasRepresentable>(of gas: Gas) -> PartialPressure<Gas> {
        .init(gas, fractionalPressure: storage[gas, default: .zero])
    }
}

extension CallSite {
    static func from<State: BlendState>(_ blend: Blend<State>, function: StaticString = #function) -> Self {
        .init(
            object: .init(describing: blend)
                .components(separatedBy: "(")
                .first
                .forceUnwrap("Couldn't extract description from \(blend)"),
            function: function)
    }
}
