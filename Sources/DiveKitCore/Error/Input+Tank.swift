import Foundation

public extension Error {
    enum Tank: Sendable {
        case ratedPressure(_ pressure: Pressure, _ tank: DiveKitCore.Tank)
        case volume(_ volume: Volume, _ tank: DiveKitCore.Tank)

    }
}

extension Error.Tank: Equatable {}
