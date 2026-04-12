import Foundation
import DiveKitCore

package extension Calculation {
    static func partialPressure<Gas: GasRepresentable>(
        _ value: Double,
        configuration: Configuration) -> Self where Result == PartialPressure<Gas> {
            self.init(
                result: .init(value),
                configuration: configuration)
        }
}
