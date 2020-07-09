//
//  Calculation.swift
//  
//
//  Created by Joshua Wood on 7/8/20.
//

import Foundation

struct Calculation {
    let value: Double
    private(set) var calculationType: CalculationType = .unspecified
    private(set) var waterType: DiveKit.WaterType = .saltWater
    private(set) var measurementUnit: DiveKit.MeasurementUnit = .imperial

    func round(to decimalPlaces: Int) -> Double {
        return value.round(to: decimalPlaces)
    }
    
    static func respiratoryMinuteVolume(value: Double = 0, diveKit: DiveKit) -> Calculation {
        return Calculation(value: value, for: .respiratoryMinuteVolume, waterType: diveKit.waterType, measurementUnit: diveKit.measurementUnit)
    }
    
    init(value: Double = 0, for calculationType: CalculationType = .unspecified, waterType: DiveKit.WaterType = .saltWater, measurementUnit: DiveKit.MeasurementUnit = .imperial) {
        self.value = value
        self.calculationType = calculationType
        self.waterType = waterType
        self.measurementUnit = measurementUnit
    }
}

extension Calculation: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Double) {
        self.value = value
    }
}

extension Calculation: ExpressibleByFloatLiteral {
    typealias FloatLiteralType = Double
    
    init(floatLiteral value: Double) {
        self.value = value
    }
}

extension Calculation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value.hashValue)
        hasher.combine(waterType.hashValue)
        hasher.combine(measurementUnit)
    }
}

extension Calculation: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value && lhs.waterType == rhs.waterType && lhs.measurementUnit == rhs.measurementUnit
    }
}

extension Calculation: Comparable {
    static func < (lhs: Calculation, rhs: Calculation) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Calculation: LosslessStringConvertible {
    init?(_ description: String) {
        guard let value = Double(description) else { return nil }
        self.value = value
    }
    var description: String {
        return String(value)
    }
}

extension Calculation {
    enum CalculationType {
        case unspecified, depthAirConsumption, respiratoryMinuteVolume, surfaceAirConsumption
    }
}
