import Foundation
import DiveKitCore

public extension Blend where State == Blended {
    static var air: Blend<Blended> {
        .init {
            FractionalPressure(.oxygen, fractionalPressure: 0.209)
            FractionalPressure(.nitrogen, fractionalPressure: 0.79)
            FractionalPressure(.trace, fractionalPressure: 0.001)
        }
    }

    static func enrichedAir(_ fraction: Double) throws(Error) -> Blend<Blended> {
        try .init { () throws(Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: fraction)
            try FractionalPressure(of: .nitrogen, fractionalPressure: 1.0 - fraction)
        }
    }
}
