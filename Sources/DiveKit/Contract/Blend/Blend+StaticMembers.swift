import Foundation

public extension Blend where State == Blended {
    static var air: Blend<Blended> {
        .init(
            .init(.oxygen, value: 0.209),
            .init(.nitrogen, value: 0.79),
            .init(.trace, value: 0.001)
        )
    }

    static func enrichedAir(_ fraction: Double) -> Blend<Blended> {
        .init(
            .init(.oxygen, value: fraction),
            .init(.nitrogen, value: 1.0 - fraction)
        )
    }
}
