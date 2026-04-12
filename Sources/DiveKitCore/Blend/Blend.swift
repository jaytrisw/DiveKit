import Foundation

public protocol BlendState: Sendable {}

public struct Blend<State: BlendState>: Sendable {
    var storage: [AnyGas: Double] = [:]

    package init(_ initialStorage: [AnyGas: Double]) {
        self.storage = initialStorage
    }

    package init<each Gas: GasRepresentable>(_ values:  repeat ((each Gas), Double)) {
        var storage: [AnyGas: Double] = [:]
        repeat _ = storage.updateValue((each values).1, forKey: .init((each values).0))
        self.init(storage)
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
