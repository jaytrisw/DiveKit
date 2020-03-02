//  DKGasCalculator.swift

import Foundation

/**
 Object used to perform gas calculations.
 - since: 1.0
 */
public class DKGasCalculator {
    
    // MARK: - Instance Properties
    private(set) var diveKit: DiveKit!
    
    /**
     Calculates the partial pressure of a gas at sea-level or a specified depth.
     
     - parameter gas: `Gas` to calculate the partial pressure.
     - parameter depth: Double presenting a depth, defaults to sea level.
     - returns: `DKPartialPressure` of constituent gases in input `DKGas` at surface pressure or input depth
     
     ### Definition
     In a mixture of gases, each constituent gas has a partial pressure which is the notional pressure of that constituent gas if it alone occupied the entire volume of the original mixture at the same temperature. The total pressure of an ideal gas mixture is the sum of the partial pressures of the gases in the mixture.
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         // Calculate partial pressure of component gases in EANx32 at 99 feet.
         let gas = DKGas.enrichedAir(percentage: 32)
         let partialPressure = try gasCalculator.partialPressure(of: gas, at: 99)
         print(partialPressure) // DKPartialPressure(oxygen: 1.28, nitrogen: 2.72, trace: 0.0)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    public func partialPressure(
        of gas: Gas,
        at depth: Double = 0
    ) throws -> PartialPressure {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be greater than 0")
        }
        var temp = gas
        try! temp.setDepth(depth, diveKit: diveKit)
        return temp.partialPressure
    }
    
    
    // MARK: - Calculation Methods
    /**
     Calculates surface air consumption of a diver
     
     - parameter depth: Double representing the depth expressed in feet or meters that the calculation was performed.
     - parameter time: Double representing the time expressed in minutes that the calculation was performed.
     - parameter gasConsumed: Double representing the amount of gas consumed expressed in psi or bar per minute during the calculation.
     - returns: Double, representing the consumed psi or bar per minute calculated for surface pressure.
     
     ### Definition
     Your Surface Air Consumption rate is a measurement of the amount of air you consume while breathing for one minute, on the surface. These values are given in the same unit of measurement you would use to measure the air in your cylinder, i.e. psi in the United States (as we use the metric system) and bar in most the rest of the world. Note, however, that your SAC rate is tank specific, meaning that it only applies to the exact size of the cylinder you will be using on your dive. For example, if you regularly dive with an 80 cubic foot tank but switch to a smaller 60 cubic foot cylinder for your next dive, you would need to recalculate your SAC rate.
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         // Calculate SAC rate
         let sac = try gasCalculator.surfaceAirConsumption(
             time: 10,
             depth: 33,
             gasConsumed: 200)
         print(sac) // 10.0 (psi/min)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    public func surfaceAirConsumption(
        time: Double,
        depth: Double,
        gasConsumed: Double
    ) throws -> Double {
        guard gasConsumed >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Gas consumed parameter must be greater than 0")
        }
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be greater than 0")
        }
        guard time >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Time parameter must be greater than 0")
        }
        let ata = try! DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        return (gasConsumed / time / ata).roundTo(decimalPlaces: 2)
    }
    
    /**
     Calculates the respiratory minute volume of a diver.
     - parameter gasConsumed: Double, representing the amount of air that was consumed during this calculation, expressed in psi or bar
     - parameter tank: `DKTank`, representing the tank used when this calculation was performed, expressed in psi or bar.
     - parameter depth: Double, representing the depth, expressed in feet or meters, that this calculation was performed.
     - parameter time: Double, representing the length of time, expressed in minutes, that this calculation was performed.
        
     - returns: Double, representing the consumed volume of air per minute express in cubic feet per minute or liters per minute calculated for surface pressure.
     
     ### Definition
     Respiratory Minute Volume is a measurement of the breathing gas that a diver consumes in one minute on the surface. RMV rates are expressed in cubic feet per minute (imperial) or liters per minute (metric), Unlike a SAC rate, an RMV rate can be used for calculations with tanks of any volume. A diver who breathes 8 cubic feet of air a minute will always breathe 8 cubic feet of air a minute regardless of the size of the tank holding the air.
     
     - since: 1.0
     
     #### Example
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         // Calculate RMV Rate
         let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
         let rmv = try gasCalculator.respiratoryMinuteVolume(
             gasConsumed: 200,
             tank: tank,
             depth: 33,
             time: 10)
         print(rmv) // 0.27 (ft3/min)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     */
    public func respiratoryMinuteVolume(
        gasConsumed: Double,
        tank: DKTank,
        depth: Double,
        time: Double
    ) throws -> Double {
        guard gasConsumed >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Gas consumed parameter must be greater than 0")
        }
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be greater than 0")
        }
        guard time >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Time parameter must be greater than 0")
        }
        guard tank.ratedPressure >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Tank rated pressure parameter must be greater than 0")
        }
        guard tank.volume >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Tank volume parameter must be greater than 0")
        }
        let ata = try! DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        let rmv = (((gasConsumed / tank.ratedPressure) * tank.volume) / ata) / time
        return rmv.roundTo(decimalPlaces: 2)
    }
    
    // MARK: - Initializers
    /**
     Initializes `DKGasCalculator` and `DiveKit` objects with default values of `DiveKit.WaterType.saltWater` and `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public init() {
        diveKit = DiveKit()
    }
    /**
     Initializes a `DKGasCalculator` object with a `DiveKit` object.
     - since: 1.0
     */
    public convenience init(with diveKit: DiveKit) {
        self.init()
        self.diveKit = diveKit
    }
    /**
     Initializes `DKGasCalculator` and `DiveKit` objects with values for `DiveKit.WaterType` and `DiveKit.MeasurementUnit`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType, measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(waterType: waterType, measurementUnit: measurementUnit)
    }
    /**
     Initializes `DKGasCalculator` and `DiveKit` objects with value for `DiveKit.WaterType` and default value of `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType) {
        self.init()
        diveKit = DiveKit(waterType: waterType)
    }
    /**
     Initializes `DKGasCalculator` and `DiveKit` objects with value for `DiveKit.MeasurementUnit` and default value of `DiveKit.WaterType.saltWater`
     - since: 1.0
     */
    public convenience init(measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(measurementUnit: measurementUnit)
    }
}
