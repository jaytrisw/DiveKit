import Foundation

public protocol BlendState: Sendable {}

public struct Blend<State: BlendState>: Sendable {
    private var storage: [AnyGas: Double] = [:]

    package init(_ initialStorage: [AnyGas: Double]) {
        self.storage = initialStorage
    }

    package init<OtherState: BlendState>(_ blend: Blend<OtherState>) {
        self.init(blend.storage)
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

    package mutating func setFractionalPressure<Gas: GasRepresentable>(_ pressure: Double, for gas: Gas) {
        set(.init(gas, fractionalPressure: pressure))
    }

    package mutating func set<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) {
        storage.updateValue(fractionalPressure.value, forKey: .init(fractionalPressure.gas))
    }
}

extension Blend: Equatable {}
extension Blend: ResultRepresentable where State == Blended {}
