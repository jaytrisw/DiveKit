//  DKPhysics.swift

import Foundation

/**
An object used to perform dive physics calculations.
- since: 0.9
*/
public class DKPhysics {
    
    private(set) var diveKit: DiveKit!
    
    // MARK: - Calculation Methods
    /**
     Calculates atmospheres absolute of a depth.
     - parameter depth: Double, representing a depth, expressed in feet or metres.
     - parameter decimalPlaces: Integer, representing the number of decimal places to round calculation to, defaults to two deciaml places.
     
     - returns: Double, representing absolute pressure at input depth.
     - since: 0.9
     
     #### Example
     ```
     // Calculate atmospheres absolute at 33 feet of salt water.
     let diveKit = DiveKit.init()
     let physics = DKPhysics.init(with: diveKit)
     let ata = physics.atmospheresAbsolute(depth: 33)
     print(ata) // 2
     ```
     */
    public func atmospheresAbsolute(
        depth: Double,
        decimalPlaces: Int = 2
    )  throws -> Double {
           guard depth >= 0 else {
               throw DKError(title: "Invalid Parameter", description: "Depth parameter must be a positive number")
           }
           guard decimalPlaces >= 0 else {
               throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be a positive number")
           }
        return try! gaugePressure(depth: depth, decimalPlaces: decimalPlaces) + 1
    }
    /**
     Calculates gauge pressure at given depth.
     - parameter depth: Double, representing a depth, expressed in feet or metres.
     - parameter decimalPlaces: Integer, representing the number of decimal places to round calculation to, defaults to two deciaml places.
     
     - returns: Double, representing absolute pressure at input depth.
     - since: 0.9
     
     #### Example
     ```
     // Calculate gauge pressure at 33 feet of salt water.
     let diveKit = DiveKit.init()
     let physics = DKPhysics.init(with: diveKit)
     let gauge = physics.gaugePressure(depth: 33)
     print(gauge) // 1
     ```
     */
    public func gaugePressure(
        depth: Double,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be a positive number")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be a positive number")
        }
        switch diveKit.measurementUnit {
        case .imperial:
            switch diveKit.waterType {
            case .saltWater:
                return ((depth / DKConstants.imperial.oneAtmosphere.saltWater)).roundTo(decimalPlaces: decimalPlaces)
            case .freshWater:
                return ((depth / DKConstants.imperial.oneAtmosphere.freshWater)).roundTo(decimalPlaces: decimalPlaces)
            }
        case .metric:
            switch diveKit.waterType {
            case .saltWater:
                return (depth / DKConstants.metric.oneAtmosphere.saltWater).roundTo(decimalPlaces: decimalPlaces)
            case .freshWater:
                return (depth / DKConstants.metric.oneAtmosphere.freshWater).roundTo(decimalPlaces: decimalPlaces)
            }
        }
    }
    
    public func pressureChange(
        from firstDepth: Double,
        to secondDepth: Double
    ) throws -> Double {
        guard firstDepth >= 0 else {
            throw DKError(title: "Invalid First Parameter", description: "First depth parameter must be a positive number")
        }
        guard secondDepth >= 0 else {
            throw DKError(title: "Invalid Second Parameter", description: "Second depth parameter must be a positive number")
        }
        let firstATA = try! atmospheresAbsolute(depth: firstDepth)
        let secondATA = try! atmospheresAbsolute(depth: secondDepth)
        return (secondATA - firstATA)
    }
    
    // MARK: - Initializers
    /**
     Initializes `DKPhysics` and `DiveKit` objects with default values of `DiveKit.WaterType.saltWater` and `DiveKit.MeasurementUnit.imperial`
     - since: 0.9
     */
    public init() {
        diveKit = DiveKit()
    }
    /**
     Initialzes a `DKPhysics` object with a `DiveKit` object.
     - since: 0.9
     */
    public convenience init(with diveKit: DiveKit) {
        self.init()
        self.diveKit = diveKit
    }
    /**
     Initializes `DKPhysics` and `DiveKit` objects with values for `DiveKit.WaterType` and `DiveKit.MeasurementUnit`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType, measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(waterType: waterType, measurementUnit: measurementUnit)
    }
    /**
     Initializes `DKPhysics` and `DiveKit` objects with value for `DiveKit.WaterType` and default value of `DiveKit.MeasurementUnit.imperial`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType) {
        self.init()
        diveKit = DiveKit(waterType: waterType)
    }
    /**
     Initializes `DKPhysics` and `DiveKit` objects with value for `DiveKit.MeasurementUnit` and default value of `DiveKit.WaterType.saltWater`
     - since: 0.9
     */
    public convenience init(measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(measurementUnit: measurementUnit)
    }
}
