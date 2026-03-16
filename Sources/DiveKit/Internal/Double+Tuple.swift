import Foundation

internal extension Double {
    func with(_ transform: () throws -> Self) rethrows -> Tuple<Self, Self> {
        try .init(first: self, second: transform())
    }
}

internal extension Double {
    func with<Other>(_ transform: (Self) throws -> Other) rethrows -> Tuple<Self, Other> {
        try .init(first: self, second: transform(self))
    }
}
