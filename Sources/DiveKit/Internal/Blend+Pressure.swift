import Foundation

internal extension Blend<Blended> {
    func pressure<G: GasRepresentable>(of gas: G) throws(DiveKit.Error) -> Double {
        try partialPressure(of: gas).fractionalPressure
    }
}
