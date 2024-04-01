import Foundation

public extension Blend {
    static var air: Blend<Blended> {
        try! Blend<Unblended>()
            .adding(.init(.oxygen, value: 0.21))
            .adding(.init(.nitrogen, value: 0.78))
            .filling(with: .trace)
            .forceBlend()
    }

    static func enrichedAir(_ fraction: Double) -> Blend<Blended> {
        try! Blend<Unblended>()
            .adding(.init(.oxygen, value: fraction))
            .filling(with: .nitrogen)
            .forceBlend()
    }
}

extension Blend where State == Unblended {
    package func forceBlend() -> Blend<Blended> {
        return .init(storage: storage)
    }
}
