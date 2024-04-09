import Foundation

extension Error.Input {
    public enum Negative {
        case depth(_ depth: Depth)
        case fractionalPressure(_ fractionalPressure: FractionalPressure)
        case minutes(_ minutes: Minutes)
        case pressure(_ pressure: Pressure)
        case volume(_ volume: Volume)
        case weight(_ weight: Mass)
    }
}

extension Error.Input.Negative: Equatable {}
