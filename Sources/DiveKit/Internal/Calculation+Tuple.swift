import Foundation

internal extension Calculation {
    func with(_ other: () throws -> Calculation) rethrows -> Tuple<Self> {
        .init(first: self, second: try other())
    }
}
