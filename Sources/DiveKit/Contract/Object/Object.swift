import Foundation

public struct Object {
    public let weight: Mass
    public let volume: Volume

    public init(weight: Mass, volume: Volume) {
        self.weight = weight
        self.volume = volume
    }
}

extension Object: Equatable {}
