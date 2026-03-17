import Foundation

public protocol BlendState: Sendable {}

public struct Blend<State: BlendState>: Sendable {
    var storage: [AnyGas: Double] = [:]

    package init(storage: [AnyGas: Double]) {
        self.storage = storage
    }

    public var totalPressure: Double {
        storage.reduce(.zero, { $0 + $1.1 })
    }

    public func fractionalPressure(of gas: some GasRepresentable) -> Double {
        .init(storage[.init(gas)] ?? .zero)
    }

    public func components() -> [any GasRepresentable] {
        storage.keys.compactMap(\.gas)
    }
}

extension Blend: Equatable {}
extension Blend: ResultRepresentable where State == Blended {}
