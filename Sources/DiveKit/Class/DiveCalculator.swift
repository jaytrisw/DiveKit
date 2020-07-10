//
//  DiveCalculator.swift
//  
//
//  Created by Joshua Wood on 7/10/20.
//

import Foundation

/// A `DiveCalculator`  to be used to performing calculations
public class DiveCalculator {
    
    /// `DiveKit` object to be used for all calculations.
    private(set) public var diveKit: DiveKit
    
    /**
     Initializes a `DiveCalculator` object with a configured `DiveKit` object.
     - since: 1.0
     */
    public init(with diveKit: DiveKit) {
        self.diveKit = diveKit
    }
    
    /**
     Initializes a `DiveCalculator` with default values of `DiveKit.WaterType.saltWater` and `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public convenience init() {
        self.init(with: DiveKit.default)
    }
    
    /**
     Initializes a `DiveCalculator` with values for `DiveKit.WaterType` and `DiveKit.MeasurementUnit`
     - parameter waterType: `DiveKit.WaterType` default value `DiveKit.WaterType.saltWater`
     - parameter measurementUnit: `DiveKit.MeasurementUnit` default value `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType = .saltWater, measurementUnit: DiveKit.MeasurementUnit = .imperial) {
        let diveKit = DiveKit.init(waterType: waterType, measurementUnit: measurementUnit)
        self.init(with: diveKit)
    }
}
