import Foundation

public struct Trace: GasRepresentable, Sendable {
    public init() {}
}

public extension GasRepresentable where Self == Trace {
    static var trace: Self {
        .init()
    }
}
