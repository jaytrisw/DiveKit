import Foundation

public struct Nitrogen: GasRepresentable {
    public init() {}
}

public extension GasRepresentable where Self == Nitrogen {
    static var nitrogen: Self {
        .init()
    }
}
