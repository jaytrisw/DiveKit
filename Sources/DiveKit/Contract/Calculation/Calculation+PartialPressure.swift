import Foundation

package extension Calculation {
    static func partialPressure<Gas: GasRepresentable>(
        _ gas: Gas,
        fractionalPressure: Double,
        configuration: Configuration) throws(DiveKit.Error) -> Self where Result == PartialPressure<Gas> {
            try self.init(
                result: .init(of: gas, fractionalPressure: fractionalPressure),
                configuration: configuration)
        }
}
