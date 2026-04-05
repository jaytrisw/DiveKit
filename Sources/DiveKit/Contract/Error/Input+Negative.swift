import Foundation

public extension Error {
    enum Negative: Sendable {
        case depth(_ depth: DiveKit.Depth)
        case partialPressure(_ partialPressure: DiveKit.PartialPressure)
        case minutes(_ minutes: DiveKit.Minutes)
        case pressure(_ pressure: DiveKit.Pressure)
        case volume(_ volume: DiveKit.Volume)
        case weight(_ weight: DiveKit.Mass)
    }
}

extension Error.Negative: Equatable {}
