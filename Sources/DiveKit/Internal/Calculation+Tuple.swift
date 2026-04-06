import Foundation

internal extension Calculation {
    func with(_ other: () throws(DiveKit.Error) -> Calculation) throws(DiveKit.Error) -> Tuple<Self, Self> {
        .init(first: self, second: try other())
    }
}
