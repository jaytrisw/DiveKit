import Foundation

package extension Calculation {
    static func partialPressure(
        _ value: Double,
        configuration: Configuration) -> Self where Result == PartialPressure {
            self.init(
                result: .init(value),
                configuration: configuration)
        }
}
