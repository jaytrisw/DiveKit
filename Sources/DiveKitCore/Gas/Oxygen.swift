import Foundation

public struct Oxygen: GasRepresentable, Sendable {
    public init() {}
}

public extension GasRepresentable where Self == Oxygen {
    static var oxygen: Self {
        .init()
    }
}
