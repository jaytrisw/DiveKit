import Foundation
import DiveKitCore

@resultBuilder
package enum BlendBuilder {
    package static func buildBlock<each Gas: GasRepresentable, State: BlendState>(
        _ components: repeat FractionalPressure<each Gas>) -> Blend<State> {
            .init(repeat ((each components).gas, (each components).value))
        }
}
