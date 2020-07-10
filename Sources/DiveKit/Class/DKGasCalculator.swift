//  DKGasCalculator.swift

import Foundation

/**
 Object used to perform gas calculations.
 - since: 1.0
 */
public class DKGasCalculator: DiveCalculator {    
    /**
     Calculates the partial pressure of a gas at sea-level or a specified depth.
     
     - parameter gas: `Gas` to calculate the partial pressure.
     - parameter depth: Double presenting a depth, defaults to sea level.
     - returns: `DKPartialPressure` of constituent gases in input `DKGas` at surface pressure or input depth
     
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
        of inputGas: Gas,
        at depth: Double = 0
    ) throws -> PartialPressure {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        var gas = inputGas
        try gas.setDepth(depth, diveKit: diveKit)
        return gas.partialPressure
    }
    
    
    // MARK: - Calculation Methods
    /**
     Calculates surface air consumption of a diver
     
     - parameter depth: Double representing the depth expressed in feet or meters that the calculation was performed.
     - parameter time: Double representing the time expressed in minutes that the calculation was performed.
     - parameter gasConsumed: Double representing the amount of gas consumed expressed in psi or bar per minute during the calculation.
     - returns: Double, representing the consumed psi or bar per minute calculated for surface pressure.
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         // Calculate SAC rate
         let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(
             time: 10,
             depth: 33,
             gasConsumed: 200)
         print(surfaceAirConsumption) // 10.0 (psi/min)
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
        guard gasConsumed >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: gasConsumed) }
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard time >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .time, value: time) }
        let atmospheresAbsolute = try DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        let depthAirConsumption = try self.depthAirConsumption(gasConsumed: gasConsumed, time: time)
        return (depthAirConsumption / atmospheresAbsolute).roundTo(decimalPlaces: 2)
    }
    
    // MARK: - Calculation Methods
    /**
     Calculates air consumption of a diver at depth
     
     - parameter time: Double representing the time expressed in minutes that the calculation was performed.
     - parameter gasConsumed: Double representing the amount of gas consumed expressed in psi or bar per minute during the calculation.
     - returns: Double, representing the consumed psi or bar per minute calculated for ambient pressure.
     - throws: `DiveKit.Error`
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         // Calculate DAC rate
         let depthAirConsumption = try gasCalculator.depthAirConsumption(
             gasConsumed: 200,
             time: 10)
         print(depthAirConsumption) // 20.0 (psi/min)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    public func depthAirConsumption(
        gasConsumed: Double,
        time: Double
    ) throws -> Double {
        guard gasConsumed >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: gasConsumed) }
        guard time >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .time, value: time) }
        return gasConsumed / time
    }
    
    /**
     Calculates the respiratory minute volume of a diver.
     - parameter gasConsumed: Double, representing the amount of air that was consumed during this calculation, expressed in psi or bar
     - parameter tank: `DKTank`, representing the tank used when this calculation was performed, expressed in psi or bar.
     - parameter depth: Double, representing the depth, expressed in feet or meters, that this calculation was performed.
     - parameter time: Double, representing the length of time, expressed in minutes, that this calculation was performed.
        
     - returns: Double, representing the consumed volume of air per minute express in cubic feet per minute or liters per minute calculated for surface pressure.
     
     - since: 1.0
     
     #### Example
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         // Calculate RMV Rate
         let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
         let respiratoryMinuteVolume = try gasCalculator.respiratoryMinuteVolume(
             gasConsumed: 200,
             tank: tank,
             depth: 33,
             time: 10)
         print(respiratoryMinuteVolume) // 0.27 (ft3/min)
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
        guard gasConsumed >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: gasConsumed) }
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard time >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .time, value: time) }
        guard tank.ratedPressure >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .tankPressure, value: tank.ratedPressure) }
        guard tank.volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: tank.volume) }
        let atmospheresAbsolute = try DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        let respiratoryMinuteVolume = (((gasConsumed / tank.ratedPressure) * tank.volume) / atmospheresAbsolute) / time
        return respiratoryMinuteVolume.roundTo(decimalPlaces: 2)
    }
}
