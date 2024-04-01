import Foundation

package extension Calculation {
    static func partialPressure<Gas: GasRepresentable>(
        _ gas: Gas,
        value: Double,
        configuration: Configuration) -> Self where Result == PartialPressure<Gas> {
            self.init(
                result: .init(gas, value: value),
                configuration: configuration)
        }
}
