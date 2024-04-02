import Foundation

public struct Tank {
    public let blend: Blend<Blended>
    public let size: Size

    public init(blend: Blend<Blended>, size: Size) {
        self.blend = blend
        self.size = size
    }

    public init(blend: Blend<Unblended>, size: Size) throws {
        self.blend = try blend.blend()
        self.size = size
    }
}

public extension Tank {
    struct Size {
        public let volume: Double
        public let ratedPressure: Double
        public let unit: Units.Volume

        public init(volume: Double, ratedPressure: Double, unit: Units.Volume) {
            self.volume = volume
            self.ratedPressure = ratedPressure
            self.unit = unit
        }
    }
}

extension Tank: Equatable {}
extension Tank.Size: Equatable {}

public extension Tank {
    static func cubicFeet(
        _ volume: Double,
        ratedPressure: Double,
        with blend: Blend<Blended>) -> Self {
            .init(
                blend: blend,
                size: .init(
                    volume: volume,
                    ratedPressure: ratedPressure,
                    unit: .cubicFeet))
    }
}
