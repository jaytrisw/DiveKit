import Foundation

public extension Blend where State == Blended {
    static var air: Blend<Blended> {
        .init(
            .init(.oxygen, fractionalPressure: 0.209),
            .init(.nitrogen, fractionalPressure: 0.79),
            .init(.trace, fractionalPressure: 0.001)
        )
    }

    static func enrichedAir(_ fraction: Double) -> Blend<Blended> {
        .init(
            .init(.oxygen, fractionalPressure: fraction),
            .init(.nitrogen, fractionalPressure: 1.0 - fraction)
        )
    }
}
