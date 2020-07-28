//  DKPhysics.swift

import Foundation

/**
A `DiveCalculator` used to perform dive physics calculations.
- since: 1.0
*/
public final class DKPhysics: DiveCalculator {
    
    /**
     Calculates atmospheres absolute of a depth.
     - parameter depth: Double, representing a depth, expressed in feet or meters.
     - returns: `Calculation`, representing absolute pressure at input depth.
     - throws: `DiveKit.Error`
     - since: 1.0
     
     #### Example
     ```
     let physicsCalculator = DKPhysics.init(with: DiveKit.default)

     do {
         // Calculate atmospheres absolute at 32 feet.
         let atmospheresAbsolute = try physicsCalculator.atmospheresAbsolute(at: 32)
         print(atmospheresAbsolute.value) // 1.9696969696969697
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     */
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
    
    /**
     Calculates gauge pressure at a given depth.
     - parameter depth: Double, representing a depth, expressed in feet or meters.
     
     - returns: `Calculation`, representing ambient pressure at input depth.
     - throws: `DiveKit.Error`
     - since: 1.0
     
     #### Example
     ```
     let physicsCalculator = DKPhysics.init(with: DiveKit.default)
     do {
         // Calculate gauge pressure at 46 feet rounding to one decimal place.
         let gaugePressure = try physicsCalculator.gaugePressure(at: 46)
         print(gaugePressure.round(to: 1)) // 1.4
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     */
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
    
    /**
     Calculates pressure change from a given depth to another.
     - parameter firstDepth: Double, representing the first depth, expressed in feet or meters.
     - parameter secondDepth: Double, representing the second depth, expressed in feet or meters.
     
     - returns: `Calculation`, representing the pressure change from one depth to a second expressed in atmospheres absolute.
     - throws: `DiveKit.Error`
     - since: 1.0
     
     #### Example
     ```
     let physicsCalculator = DKPhysics.init(with: DiveKit.default)
     do {
         // Calculate pressure change from at 33 feet to 99 feet.
         let pressureChange = try physicsCalculator.pressureChange(from: 33, to: 99)
         print(pressureChange.value) // 2.0
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
    */
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
    
    /**
     Calculates the surface volume of a specified volume of air at a specified depth.
     - parameter depth: The depth to perform calculation.
     - parameter volume: The volume of air to calculate.
     
     - returns: `Calculation` representing the volume of air at surface pressure
     - throws: `DiveKit.Error`
     - since: 1.0
     
     #### Example
     ```
     let physicsCalculator = DKPhysics.init(with: DiveKit.default)

     do {
         let airVolumeToSurface = try physicsCalculator.airVolumeToSurface(from: 10, volume: 10)
         print(airVolumeToSurface.value) // 13.03030303030303
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
    */
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
    
    /**
     Calculates the volume of a specified volume of air on the surface to a specified depth.
     - parameter depth: The depth to perform calculation.
     - parameter volume: The volume of air to calculate.
     
     - returns: `Calculation` representing the volume of air at specified depth
     - throws: `DiveKit.Error`
     - since: 1.0
     
     #### Example
     ```
     let physicsCalculator = DKPhysics.init(with: DiveKit.default)

     do {
         let airVolumeFromSurface = try physicsCalculator.airVolumeFromSurface(to: 10, volume: 10)
         print(airVolumeFromSurface.value) // 7.674418604651163
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
    */
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

@available(*, deprecated)
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
    public func pressureChange(
        from firstDepth: Double,
        to secondDepth: Double,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard firstDepth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: firstDepth) }
        guard secondDepth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: secondDepth) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try pressureChange(from: firstDepth, to: secondDepth).value
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
    public func atmospheresAbsolute(
        depth: Double,
        decimalPlaces: Int = 2
    )  throws -> Double {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try atmospheresAbsolute(at: depth).round(to: decimalPlaces)
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
    public func gaugePressure(
        depth: Double,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try gaugePressure(at: depth).round(to: decimalPlaces)
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
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: volume) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try airVolumeFromSurface(to: depth, volume: volume).round(to: decimalPlaces)
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
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: volume) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try airVolumeToSurface(from: depth, volume: volume).round(to: decimalPlaces)
    }
}
