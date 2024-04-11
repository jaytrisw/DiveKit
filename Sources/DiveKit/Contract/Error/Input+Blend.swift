import Foundation

public extension Error {
    enum Blend {
        case totalPressure(_ totalPressure: Double, _ blend: DiveKit.Blend<Unblended>)
        case pressureRange(_ pressureRange: Double, _ blend: DiveKit.Blend<Unblended>)
    }
}

extension Error.Blend: Equatable {}
