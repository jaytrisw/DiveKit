import Foundation

package extension Calculation {
    static func partialPressure<Gas: GasRepresentable>(
        _ gas: Gas,
        fractionalPressure: Double,
        configuration: Configuration) -> Self where Result == PartialPressure<Gas> {
            self.init(
                result: .init(gas, fractionalPressure: fractionalPressure),
                configuration: configuration)
        }
}
