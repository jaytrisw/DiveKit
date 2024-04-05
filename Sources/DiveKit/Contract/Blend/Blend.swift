import Foundation

public protocol BlendState {}

public struct Blend<State: BlendState> {
    var storage: [AnyHashable: Double] = [:]

    init(storage: [AnyHashable : Double]) {
        self.storage = storage
    }

    public var totalPressure: Double {
        storage.values.reduce(.zero, { $0 + $1 })
    }
}

extension Blend: Equatable {}
extension Blend: ResultRepresentable where State == Blended {}
