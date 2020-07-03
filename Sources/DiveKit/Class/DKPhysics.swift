//  DKPhysics.swift

import Foundation

/**
An object used to perform dive physics calculations.
- since: 1.0
*/
public class DKPhysics {
    
    private(set) var diveKit: DiveKit!
    
    // MARK: - Calculation Methods
    /**
     Calculates atmospheres absolute of a depth.
     - parameter depth: Double, representing a depth, expressed in feet or meters.
     - parameter decimalPlaces: Integer, representing the number of decimal places to round calculation to, defaults to two decimal places.
     - returns: Double, representing absolute pressure at input depth.
     - since: 1.0
     
     ### Definition
     The sum of barometric, or the pressure exerted by the atmosphere, and hydrostatic, or the pressure exerted by a water column, pressures.
     
     #### Example
     ```
     let physicsCalculator = DKPhysics.init(waterType: .saltWater, measurementUnit: .imperial)
     do {
         // Calculate atmospheres absolute at 32 feet rounding to four decimal places.
         let ata = try physicsCalculator.atmospheresAbsolute(depth: 32, decimalPlaces: 4)
         print(ata) // 1.9697 (ata)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
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
     Calculates gauge pressure at a given depth.
     - parameter depth: Double, representing a depth, expressed in feet or meters.
     - parameter decimalPlaces: Integer, representing the number of decimal places to round calculation to, defaults to two decimal places.
     
     - returns: Double, representing ambient pressure at input depth.
     - since: 1.0
     
     ### Definition
     As you climb above sea level, the atmospheric pressure decreases because the amount of air above you weighs less. If you dive below sea level, the opposite occurs (the pressure increases) because water has weight that is greater than air. Thus, the deeper one descends underwater the greater the pressure.
     
     #### Example
     ```
     let physicsCalculator = DKPhysics.init(waterType: .saltWater, measurementUnit: .imperial)
     do {
         // Calculate gauge pressure at 46 feet rounding to one decimal place.
         let gaugePressure = try physicsCalculator.gaugePressure(depth: 46, decimalPlaces: 1)
         print(gaugePressure) // 1.4 (ata)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
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
        // Depth / One Atmosphere Depth
        let gaugePressure = depth / diveKit.constants.oneAtmosphere
        return gaugePressure.roundTo(decimalPlaces: decimalPlaces)
    }
    
    /**
    Calculates pressure change from a given depth to another.
    - parameter firstDepth: Double, representing the first depth, expressed in feet or meters.
    - parameter secondDepth: Double, representing the second depth, expressed in feet or meters.
     
    - returns: Double, representing the pressure change from one depth to a second expressed in atmospheres absolute.
    - since: 1.0
    
    #### Example
    ```
    let physicsCalculator = DKPhysics.init(waterType: .saltWater, measurementUnit: .imperial)
    do {
        // Calculate pressure change from at 33 feet to 99 feet.
        let pressureChange = try physicsCalculator.pressureChange(from: 33, to: 99)
        print(pressureChange) // 2 (ata)
    } catch {
        // Handle Error
        print(error.localizedDescription)
    }
    ```
    */
    public func pressureChange(
        from firstDepth: Double,
        to secondDepth: Double,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard firstDepth >= 0 else {
            throw DKError(title: "Invalid First Parameter", description: "First depth parameter must be a positive number")
        }
        guard secondDepth >= 0 else {
            throw DKError(title: "Invalid Second Parameter", description: "Second depth parameter must be a positive number")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be a positive number")
        }
        let firstATA = try! atmospheresAbsolute(depth: firstDepth)
        let secondATA = try! atmospheresAbsolute(depth: secondDepth)
        return (secondATA - firstATA).roundTo(decimalPlaces: decimalPlaces)
        
    }
    
    /// Calculates the volume of a specified volume of air on the surface to a specified depth
    /// - Parameters:
    ///   - volume: The volume of air to calculate
    ///   - depth: The depth to perform calculation
    ///   - decimalPlaces: The number of decimal places to round calculation to
    /// - Throws: DKError
    /// - Returns: The volume of air at specified depth
    public func airVolumeFromSurface(
        volume: Double,
        depth: Double,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be a positive number")
        }
        guard volume >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Volume parameter must be a positive number")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be a positive number")
        }
        let ata = try! atmospheresAbsolute(depth: depth)
        return (volume / ata).roundTo(decimalPlaces: decimalPlaces)
    }
    
    /// Calculates the surface volume of a specified volume of air at a specified depth
    /// - Parameters:
    ///   - volume: The volume of air to calculate
    ///   - depth: The depth to perform calculation
    ///   - decimalPlaces: The number of decimal places to round calculation to
    /// - Throws: DKError
    /// - Returns: The volume of air at surface pressure
    public func airVolumeToSurface(
        volume: Double,
        depth: Double,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be a positive number")
        }
        guard volume >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Volume parameter must be a positive number")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be a positive number")
        }
        let ata = try! atmospheresAbsolute(depth: depth)
        return (volume * ata).roundTo(decimalPlaces: decimalPlaces)
    }
    
    // MARK: - Initializers
    /**
     Initializes `DKPhysics` and `DiveKit` objects with default values of `DiveKit.WaterType.saltWater` and `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public init() {
        diveKit = DiveKit()
    }
    /**
     Initializes a `DKPhysics` object with a `DiveKit` object.
     - since: 1.0
     */
    public convenience init(with diveKit: DiveKit) {
        self.init()
        self.diveKit = diveKit
    }
    /**
     Initializes `DKPhysics` and `DiveKit` objects with values for `DiveKit.WaterType` and `DiveKit.MeasurementUnit`
     - parameter waterType: `DiveKit.WaterType` default value `DiveKit.WaterType.saltWater`
     - parameter measurementUnit: `DiveKit.MeasurementUnit` default value `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType = .saltWater, measurementUnit: DiveKit.MeasurementUnit = .imperial) {
        self.init()
        diveKit = DiveKit(waterType: waterType, measurementUnit: measurementUnit)
    }
}
