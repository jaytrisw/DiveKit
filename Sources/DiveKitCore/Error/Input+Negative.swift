import Foundation

public extension Error {
    enum Negative: Sendable {
        case depth(_ depth: Depth)
        case fractionalPressure(_ fractionalPressure: Double)
        case partialPressure(_ partialPressure: Double)
        case minutes(_ minutes: Minutes)
        case pressure(_ pressure: Pressure)
        case volume(_ volume: Volume)
        case weight(_ weight: Mass)
    }
}

extension Error.Negative: Equatable {}
