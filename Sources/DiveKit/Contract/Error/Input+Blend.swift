import Foundation

public extension Error.Input {
    enum Blend {
        case totalPressure(_ totalPressure: Double, _ blend: DiveKit.Blend<Unblended>)
        case pressureRange(_ pressureRange: Double, _ blend: DiveKit.Blend<Unblended>)
    }
}

extension Error.Input.Blend: Equatable {}
