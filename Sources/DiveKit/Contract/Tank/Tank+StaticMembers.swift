import Foundation

public extension Tank {
    static func cubicFeet(
        _ volume: Volume,
        ratedPressure: Pressure,
        with blend: Blend<Blended>) -> Self {
            .init(
                blend: blend,
                size: .init(
                    volume: volume,
                    ratedPressure: ratedPressure,
                    unit: .cubicFeet))
        }
}
