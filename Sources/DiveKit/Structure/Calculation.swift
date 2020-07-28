import Foundation
/**
 A value type that represents the calculations performs by a `DiveCalculator`
 - since: 1.0
 */
public struct Calculation: Codable {
    /// Double representing the calculated value
    private(set) public var value: Double
    /// The `Calculation.CalculationType` of calculation.
    private(set) public var calculationType: CalculationType = .unspecified
    /// The `DiveKit.WaterType` use for the calculation.
    private(set) public var waterType: DiveKit.WaterType = .saltWater
    /// The `DiveKit.MeasurementUnit` use for the calculation.
    private(set) public var measurementUnit: DiveKit.MeasurementUnit = .imperial

    /// Returns a double rounded to the specified number of decimal places
    public func round(to decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return (value * divisor).rounded(.toNearestOrEven) / divisor
    }
    
    init(value: Double, for calculationType: CalculationType, waterType: DiveKit.WaterType = .saltWater, measurementUnit: DiveKit.MeasurementUnit = .imperial) {
        self.value = value
        self.calculationType = calculationType
        self.waterType = waterType
        self.measurementUnit = measurementUnit
    }
    
    init(value: Double, for calculationType: CalculationType, diveKit: DiveKit) {
        self.value = value
        self.calculationType = calculationType
        self.waterType = diveKit.waterType
        self.measurementUnit = diveKit.measurementUnit
    }
}

extension Calculation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value.hashValue)
        hasher.combine(waterType.hashValue)
        hasher.combine(measurementUnit.hashValue)
    }
}

extension Calculation: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value && lhs.waterType == rhs.waterType && lhs.measurementUnit == rhs.measurementUnit && lhs.calculationType == rhs.calculationType
    }
}

extension Calculation: Comparable {
    public static func < (lhs: Calculation, rhs: Calculation) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Calculation {
    /// The type of calculation performed.
    public enum CalculationType: Int, Codable {
        /// Unspecified, representing an unspecified calculation type.
        case unspecified
        /// Depth Air Consumption
        case depthAirConsumption
        /// Respiratory Minute Volume
        case respiratoryMinuteVolume
        /// Surface Air Consumption
        case surfaceAirConsumption
        /// Atmospheres Absolute
        case atmospheresAbsolute
        /// Gauge Pressure
        case gaugePressure
        /// Pressure Change
        case pressureChange
        /// Air Volume To Surface
        case airVolumeToSurface
        /// Air Volume From Surface
        case airVolumeFromSurface
        /// Maximum Operating Depth
        case maximumOperatingDepth
        /// Equivalent Air Depth
        case equivalentAirDepth
    }
}
