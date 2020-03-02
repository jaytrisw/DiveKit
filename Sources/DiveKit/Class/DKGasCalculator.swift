//  DKGasCalculator.swift

import Foundation

/**
 Object used to perform gas calculations.
 - since: 0.9
 */
public class DKGasCalculator {
    
    // MARK: - Instance Properties
    private(set) var diveKit: DiveKit!
    
    /**
     Calculates the partial pressure of a gas at sea-level or a specified depth.
     
     - parameter gas: `DKGas` to calculate the partial pressure.
     - parameter depth: Double presenting a depth, defaults to sea level.
     - returns: `DKPartialPressure` of constituent gases in input `DKGas` at surface pressure or input depth
     
     ### Definition
     In a mixture of gases, each constituent gas has a partial pressure which is the notional pressure of that constituent gas if it alone occupied the entire volume of the original mixture at the same temperature. The total pressure of an ideal gas mixture is the sum of the partial pressures of the gases in the mixture.
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()
     let partialPressure = gasCalculator.partialPressure(of: .air, at: 33)
     print(partialPressure) // DKPartialPressure(oxygen: 0.418, nitrogen: 1.58, trace: 0.002)
     ```
     - since: 0.9
     */
    public func partialPressure(of gas: DKGas, at depth: Double = 0) -> DKPartialPressure {
        let ata = try! DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        switch gas {
        case .air:
            if depth >= 0 {
                return DKPartialPressure(oxygen: DKGas.air.partialPressure.oxygen * ata, nitrogen: DKGas.air.partialPressure.nitrogen * ata, trace: DKGas.air.partialPressure.trace * ata)
            }
        case .enrichedAir(let blend):
            if depth >= 0 {
                return DKPartialPressure(oxygen: DKGas.enrichedAir(percentage: blend).partialPressure.oxygen * ata, nitrogen: DKGas.enrichedAir(percentage: blend).partialPressure.nitrogen * ata, trace: DKGas.enrichedAir(percentage: blend).partialPressure.trace * ata)
            }
        }
        return gas.partialPressure
    }
    
    // MARK: - Calculation Methods
    /**
     Calculates surface air consumption of a diver
     
     - parameter depth: The depth, expressed in **feet** or **metres**, that this calculation was performed.
     - parameter time: The length of time, expressed in minutes, that this calculation was performed.
     - parameter gasConsumed: The amount of air, expressed in **PSI** or **Bar**, that was consumed during this calculation.
     - returns: Double, representing consumed pressure of air per minute calculated for surface pressure.  Expressed in psi or bar per minute
     
     # Example #
     ```
     let diveKit = DiveKit.init()
     let gasCalculator = DKGasCalculator.init(with: diveKit)
     gasCalculator.surfaceAirConsumption(
         time: 10,
         depth: 33,
         gasConsumed: 200)
     ```
     - since: 0.9
     */
    public func surfaceAirConsumption(
        time: Double,
        depth: Double,
        gasConsumed: Double
    ) -> Double {
        let ata = try! DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        return (gasConsumed / time / ata).roundTo(decimalPlaces: 2)
    }
    
    /**
     Calculates respiratory minute volume of a diver.
     - parameter gasConsumed: Double, representing the amount of air that was consumed during this calculation, expressed in psi or bar
     - parameter tank: `DKTank`, representing the tank used when this calculation was performed, expressed in psi or bar.
     - parameter depth: Double, representing the depth, expressed in feet or metres, that this calculation was performed.
     - parameter time: Double, representing the length of time, expressed in minutes, that this calculation was performed.
          
     - returns: Double, representing consumed volume of air per minute calculated for surface pressure.  Expressed in cubic feet per minute or litres per minute
     - since: 0.9
     - version: 0.9.0.3
     
     #### Example
     ```
     let diveKit = DiveKit.init()
     let gasCalculator = DKGasCalculator.init(with: diveKit)
     let tank - DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
     let rmv = gasCalculator.respiratoryMinuteVolume(
         gasConsumed: 200,
         tank: tank,
         depth: 33,
         time: 10)
     ```
     */
    public func respiratoryMinuteVolume(
        gasConsumed: Double,
        tank: DKTank,
        depth: Double,
        time: Double
    ) -> Double {
        let ata = try! DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        let rmv = (((gasConsumed / tank.ratedPressure) * tank.volume) / ata) / time
        return rmv.roundTo(decimalPlaces: 2)
    }
    
    // MARK: - Initializers
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with default values of `DiveKit.WaterType.saltWater` and `DiveKit.MeasurementUnit.imperial`
     - since: 0.9
     */
    public init() {
        diveKit = DiveKit()
    }
    /**
     Initialzes a `DKEnrichedAir` object with a `DiveKit` object.
     - since: 0.9
     */
    public convenience init(with diveKit: DiveKit) {
        self.init()
        self.diveKit = diveKit
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with values for `DiveKit.WaterType` and `DiveKit.MeasurementUnit`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType, measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(waterType: waterType, measurementUnit: measurementUnit)
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with value for `DiveKit.WaterType` and default value of `DiveKit.MeasurementUnit.imperial`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType) {
        self.init()
        diveKit = DiveKit(waterType: waterType)
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with value for `DiveKit.MeasurementUnit` and default value of `DiveKit.WaterType.saltWater`
     - since: 0.9
     */
    public convenience init(measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(measurementUnit: measurementUnit)
    }
}
