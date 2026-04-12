import Foundation

public extension Error {
    enum Blend: Sendable {
        case totalPressure(_ totalPressure: Double, _ blend: DiveKitCore.Blend<Unblended>)
        case pressureRange(_ pressureRange: Double, _ blend: DiveKitCore.Blend<Unblended>)
    }
}

extension Error.Blend: Equatable {}
