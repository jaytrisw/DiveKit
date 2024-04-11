import Foundation

public extension Error.Input {
    enum Tank {
        case ratedPressure(_ pressure: DiveKit.Pressure, _ tank: DiveKit.Tank)
        case volume(_ volume: DiveKit.Volume, _ tank: DiveKit.Tank)

    }
}

extension Error.Input.Tank: Equatable {}
