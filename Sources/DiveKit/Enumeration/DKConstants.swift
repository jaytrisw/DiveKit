//
//  DKConstants.swift
//

import Foundation

/**
 An object the represents constant vaules for weight and pressure.
 */
public enum DKConstants {
    /// Imperial Units
    case imperial
    /// Metric Units
    case metric
    /// A property that contains the constant number of feet or meters of a water column that equals one atmosphere of pressure.
    public var oneAtmosphere: DKAtmosphereContants {
        switch self {
        case .imperial:
            return DKAtmosphereContants(saltWater: 33, freshWater: 34)
        case .metric:
            return DKAtmosphereContants(saltWater: 10, freshWater: 10.3)
        }
    }
    /// A property that contains the constant weight of a volume of freshwater or saltwater and the unit of measure.
    public var weightOfWaterByUnit: DKWeightOfWater {
        switch self {
        case .imperial:
            return DKWeightOfWater(saltWater: 64, freshWater: 62.4, unit: .pounds, volume: .oneCubicFoot)
        case .metric:
            return DKWeightOfWater(saltWater: 1.03, freshWater: 1.0, unit: .kilograms, volume: .oneLitre)
        }
    }
    /// A property that contains a constant value of pressure change per foot or meter when descending into freshwater or saltwater.
    public var pressureChange: DKPressureChange {
        switch self {
        case .imperial:
            return DKPressureChange(saltWater: 0.0303, freshWater: 0.0294)
        case .metric:
            return DKPressureChange(saltWater: 0.100, freshWater: 0.097)
        }
    }
}
