import DiveKitCore

package extension Calculation {
    func map(_ transform: (Calculation) -> Calculation) -> Calculation {
        transform(self)
    }
}
