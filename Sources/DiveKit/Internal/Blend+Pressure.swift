import Foundation

internal extension Blend<Blended> {
    func pressure<G: GasRepresentable>(of gas: G) -> Double {
        partialPressure(of: gas).fractionalPressure
    }
}
