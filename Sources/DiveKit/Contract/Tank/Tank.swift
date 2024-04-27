import Foundation

public struct Tank {
    public let blend: Blend<Blended>
    public let size: Size

    public init(blend: Blend<Blended>, size: Size) {
        self.blend = blend
        self.size = size
    }

    public init(blend: Blend<Unblended>, size: Size) throws {
        self.blend = try blend.blend(.init(object: .init(describing: Self.self), function: #function))
        self.size = size
    }
}

extension Tank: Equatable {}
