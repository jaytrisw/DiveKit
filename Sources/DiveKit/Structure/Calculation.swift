//
//  Calculation.swift
//  
//
//  Created by Joshua Wood on 7/8/20.
//

public struct Calculation {
    let value: Double
    private(set) var calculationType: CalculationType = .unspecified
    private(set) var waterType: DiveKit.WaterType = .saltWater
    private(set) var measurementUnit: DiveKit.MeasurementUnit = .imperial

    func round(to decimalPlaces: Int) -> Double {
        return value.round(to: decimalPlaces)
    }
    
    static func depthAirConsumption(value: Double, diveKit: DiveKit) -> Calculation {
        return Calculation(value: value, for: .depthAirConsumption, waterType: diveKit.waterType, measurementUnit: diveKit.measurementUnit)
    }
    
    static func respiratoryMinuteVolume(value: Double, diveKit: DiveKit) -> Calculation {
        return Calculation(value: value, for: .respiratoryMinuteVolume, waterType: diveKit.waterType, measurementUnit: diveKit.measurementUnit)
    }
    
    static func surfaceAirConsumption(value: Double, diveKit: DiveKit) -> Calculation {
        return Calculation(value: value, for: .surfaceAirConsumption, waterType: diveKit.waterType, measurementUnit: diveKit.measurementUnit)
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

extension Calculation: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Double) {
        self.value = value
    }
}

extension Calculation: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    
    public init(floatLiteral value: Double) {
        self.value = value
    }
}

extension Calculation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value.hashValue)
        hasher.combine(waterType.hashValue)
        hasher.combine(measurementUnit)
    }
}

extension Calculation: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value && lhs.waterType == rhs.waterType && lhs.measurementUnit == rhs.measurementUnit
    }
}

extension Calculation: Comparable {
    public static func < (lhs: Calculation, rhs: Calculation) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Calculation: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let value = Double(description) else { return nil }
        self.value = value
    }
    public var description: String {
        return String(value)
    }
}

extension Calculation {
    public enum CalculationType {
        case unspecified, depthAirConsumption, respiratoryMinuteVolume, surfaceAirConsumption, atmospheresAbsolute, gaugePressure, pressureChange, airVolumeToSurface, airVolumeFromSurface
    }
}
