//  DKPhysics.swift

import Foundation

/**
An object used to perform dive physics calculations.
- since: 1.0
*/
public class DKPhysics: DiveCalculator {
    
    public func atmospheresAbsolute(
        at depth: Depth
    ) throws -> Calculation {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        let gaugePressure = try self.gaugePressure(at: depth)
        return Calculation(
            value: gaugePressure.value + 1,
            for: .atmospheresAbsolute,
            diveKit: diveKit
        )
    }
    public func gaugePressure(
        at depth: Depth
    ) throws -> Calculation {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        let gaugePressure = depth / diveKit.constants.oneAtmosphere
        return Calculation(
            value: gaugePressure,
            for: .gaugePressure,
            diveKit: diveKit
        )
    }
    public func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth
    ) throws -> Calculation {
        guard firstDepth >= 0 else {
            throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: firstDepth)
        }
        guard secondDepth >= 0 else {
            throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: secondDepth)
        }
        let firstATA = try atmospheresAbsolute(at: firstDepth)
        let secondATA = try atmospheresAbsolute(at: secondDepth)
        return Calculation(
            value: secondATA.value - firstATA.value,
            for: .pressureChange,
            diveKit: diveKit
        )
    }
    
    public func airVolumeToSurface(
        from depth: Depth,
        volume: Volume
    ) throws -> Calculation {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: volume) }
        let atmospheresAbsolute = try self.atmospheresAbsolute(at: depth)
        return Calculation(
            value: volume * atmospheresAbsolute.value,
            for: .airVolumeToSurface,
            diveKit: diveKit
        )
    }
    
    public func airVolumeFromSurface(
        to depth: Depth,
        volume: Volume
    ) throws -> Calculation {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: volume) }
        let atmospheresAbsolute = try self.atmospheresAbsolute(at: depth)
        return Calculation(
            value: volume / atmospheresAbsolute.value,
            for: .airVolumeFromSurface,
            diveKit: diveKit
        )
    }
}


extension DKPhysics {
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
    @available(*, deprecated)
    public func pressureChange(
        from firstDepth: Double,
        to secondDepth: Double,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard firstDepth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: firstDepth) }
        guard secondDepth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: secondDepth) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        let firstATA = try atmospheresAbsolute(depth: firstDepth)
        let secondATA = try atmospheresAbsolute(depth: secondDepth)
        return (secondATA - firstATA).round(to: decimalPlaces)
    }
    /**
     Calculates atmospheres absolute of a depth.
     - parameter depth: Double, representing a depth, expressed in feet or meters.
     - parameter decimalPlaces: Integer, representing the number of decimal places to round calculation to, defaults to two decimal places.
     - returns: Double, representing absolute pressure at input depth.
     - since: 1.0
     
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
    @available(*, deprecated)
    public func atmospheresAbsolute(
        depth: Double,
        decimalPlaces: Int = 2
    )  throws -> Double {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try gaugePressure(depth: depth, decimalPlaces: decimalPlaces) + 1
    }
    
    /**
     Calculates gauge pressure at a given depth.
     - parameter depth: Double, representing a depth, expressed in feet or meters.
     - parameter decimalPlaces: Integer, representing the number of decimal places to round calculation to, defaults to two decimal places.
     
     - returns: Double, representing ambient pressure at input depth.
     - since: 1.0
     
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
    @available(*, deprecated)
    public func gaugePressure(
        depth: Double,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        // Depth / One Atmosphere Depth
        let gaugePressure = depth / diveKit.constants.oneAtmosphere
        return gaugePressure.round(to: decimalPlaces)
    }
    
    /// Calculates the volume of a specified volume of air on the surface to a specified depth
    /// - Parameters:
    ///   - volume: The volume of air to calculate
    ///   - depth: The depth to perform calculation
    ///   - decimalPlaces: The number of decimal places to round calculation to
    /// - Throws: DKError
    /// - Returns: The volume of air at specified depth
    @available(*, deprecated)
    public func airVolumeFromSurface(
        volume: Double,
        depth: Double,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: volume) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        let ata = try atmospheresAbsolute(depth: depth)
        return (volume / ata).round(to: decimalPlaces)
    }
    
    /// Calculates the surface volume of a specified volume of air at a specified depth
    /// - Parameters:
    ///   - volume: The volume of air to calculate
    ///   - depth: The depth to perform calculation
    ///   - decimalPlaces: The number of decimal places to round calculation to
    /// - Throws: DKError
    /// - Returns: The volume of air at surface pressure
    @available(*, deprecated)
    public func airVolumeToSurface(
        volume: Double,
        depth: Double,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: volume) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        let ata = try atmospheresAbsolute(depth: depth)
        return (volume * ata).round(to: decimalPlaces)
    }
}
