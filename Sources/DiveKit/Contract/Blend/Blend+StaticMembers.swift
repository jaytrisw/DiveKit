import Foundation

public extension Blend where State == Blended {
    static var air: Blend<Blended> {
        .init {
            PartialPressure(.oxygen, fractionalPressure: 0.209)
            PartialPressure(.nitrogen, fractionalPressure: 0.79)
            PartialPressure(.trace, fractionalPressure: 0.001)
        }
    }

    static func enrichedAir(_ fraction: Double) throws(DiveKit.Error) -> Blend<Blended> {
        try .init { () throws(DiveKit.Error) in
            try PartialPressure(of: .oxygen, fractionalPressure: fraction)
            try PartialPressure(of: .nitrogen, fractionalPressure: 1.0 - fraction)
        }
    }
}
