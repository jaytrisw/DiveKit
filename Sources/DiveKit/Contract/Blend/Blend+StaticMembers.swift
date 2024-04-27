import Foundation

public extension Blend where State == Blended {
    static var air: Blend<Blended> {
        .init {
            PartialPressure(.oxygen, fractionalPressure: 0.209)
            PartialPressure(.nitrogen, fractionalPressure: 0.79)
            PartialPressure(.trace, fractionalPressure: 0.001)
        }
    }

    static func enrichedAir(_ fraction: Double) -> Blend<Blended> {
        .init {
            PartialPressure(.oxygen, fractionalPressure: fraction)
            PartialPressure(.nitrogen, fractionalPressure: 1.0 - fraction)
        }
    }
}
