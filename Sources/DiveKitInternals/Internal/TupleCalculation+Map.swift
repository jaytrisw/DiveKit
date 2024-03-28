import DiveKitCore

package extension TupleCalculation {
    func map<C>(_ transform: (TupleCalculation) -> C) -> C {
        transform(self)
    }
}
