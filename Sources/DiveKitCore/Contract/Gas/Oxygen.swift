import Foundation

public struct Oxygen: GasRepresentable {
    public init() {}
}

public extension GasRepresentable where Self == Oxygen {
    static var oxygen: Self {
        .init()
    }
}
