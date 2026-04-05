import Foundation

internal extension Blend<Blended> {
    func fraction<G: GasRepresentable>(of gas: G) throws(DiveKit.Error) -> Double {
        try partialPressure(of: gas).fractionalPressure
    }
}
