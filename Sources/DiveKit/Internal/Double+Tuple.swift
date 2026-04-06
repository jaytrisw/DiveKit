import Foundation

internal extension Double {
    func with(_ transform: () throws(DiveKit.Error) -> Self) throws(DiveKit.Error) -> Tuple<Self, Self> {
        try .init(first: self, second: transform())
    }
}

internal extension Double {
    func with<Other>(_ transform: (Self) throws(DiveKit.Error) -> Other) throws(DiveKit.Error) -> Tuple<Self, Other> {
        try .init(first: self, second: transform(self))
    }
}
