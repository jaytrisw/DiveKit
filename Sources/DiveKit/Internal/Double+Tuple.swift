import Foundation

internal extension Double {
    func with(_ transform: () throws -> Self) rethrows -> Tuple<Self> {
        try .init(first: self, second: transform())
    }
}
