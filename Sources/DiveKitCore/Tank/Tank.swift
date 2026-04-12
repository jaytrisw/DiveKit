import Foundation

public struct Tank: Sendable {
    public let blend: Blend<Blended>
    public let size: Size

    public init(blend: Blend<Blended>, size: Size) {
        self.blend = blend
        self.size = size
    }
}

extension Tank: Equatable {}
