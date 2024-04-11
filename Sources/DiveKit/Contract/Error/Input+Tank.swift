import Foundation

public extension Error {
    enum Tank {
        case ratedPressure(_ pressure: DiveKit.Pressure, _ tank: DiveKit.Tank)
        case volume(_ volume: DiveKit.Volume, _ tank: DiveKit.Tank)

    }
}

extension Error.Tank: Equatable {}
