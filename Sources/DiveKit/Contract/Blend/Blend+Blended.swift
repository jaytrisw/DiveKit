import Foundation

public enum Blended: BlendState, Sendable {}

public extension Blend where State == Blended {
    func partialPressure<Gas: GasRepresentable>(of gas: Gas) throws(DiveKit.Error) -> FractionalPressure<Gas> {
        try .init(of: gas, fractionalPressure: fractionalPressure(of: gas))
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
