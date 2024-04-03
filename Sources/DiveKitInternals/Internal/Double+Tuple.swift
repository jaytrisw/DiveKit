import DiveKitCore

package extension Double {
    func with(_ transform: () -> Self) -> Tuple<Self> {
        .init(first: self, second: transform())
    }
}
