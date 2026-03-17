import Foundation

public protocol GasRepresentable: Hashable, Sendable {}

public extension GasRepresentable {
    func isEqual<Gas: GasRepresentable>(to other: Gas) -> Bool {
        AnyGas(self) == .init(other)
    }
}
