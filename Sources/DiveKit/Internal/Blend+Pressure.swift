import Foundation

internal extension Blend<Blended> {
    func fractionValue<G: GasRepresentable>(of gas: G) throws(DiveKit.Error) -> Double {
        try fraction(of: gas).value
    }
}
