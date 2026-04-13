import Foundation
import DiveKitCore

public extension Blend where State == Blended {
    func fractionalPressure<Gas: GasRepresentable>(of gas: Gas) throws(Error) -> FractionalPressure<Gas> {
        try .init(of: gas, fractionalPressure: fractionalPressure(of: gas))
    }
}

extension CallSite {
    static func from<State: BlendState>(_ blend: Blend<State>, function: StaticString = #function) -> Self {
        let object = String(describing: blend)
            .components(separatedBy: "(")
            .first ?? String(describing: blend)

        return .init(
            object: object,
            function: function)
    }
}
