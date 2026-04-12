import Foundation

package extension Double {
    func with(_ transform: () throws(Error) -> Self) throws(Error) -> Tuple<Self, Self> {
        try .init(first: self, second: transform())
    }
}

package extension Double {
    func with<Other>(_ transform: (Self) throws(Error) -> Other) throws(Error) -> Tuple<Self, Other> {
        try .init(first: self, second: transform(self))
    }
}
