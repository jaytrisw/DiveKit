//  DKGasCalculator.swift

public typealias Depth = Double
public typealias Minutes = Double
public typealias Pressure = Double
public typealias SurfaceAirConsumption = Calculation

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
        at depth: Depth = 0
    ) throws -> PartialPressure {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        var gas = inputGas
        try gas.setDepth(depth, diveKit: diveKit)
        return gas.partialPressure
    }
    
    
    // MARK: - Calculation Methods
    
    public func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure
    ) throws -> Calculation {
        // Handle Error Cases
        let atmospheresAbsolute = try DKPhysics(with: diveKit).atmospheresAbsolute(depth: depth)
        let depthAirConsumption = try self.depthAirConsumption(for: minutes, consuming: gasConsumed)
        let surfaceAirConsumption = depthAirConsumption.value / atmospheresAbsolute
        return Calculation.surfaceAirConsumption(
            value: surfaceAirConsumption,
            diveKit: self.diveKit
        )
    }
    
    public func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        startGas: Pressure,
        endGas: Pressure
    ) throws -> Calculation {
        // Handle Error Cases
        let gasConsumed = startGas - endGas
        return try surfaceAirConsumption(
            at: depth,
            for: minutes,
            consuming: gasConsumed
        )
    }
    
    public func respiratoryMinuteVolume(
        at depth: Depth,
        for minutes: Minutes,
        with tank: DKTank,
        consuming gasConsumed: Pressure
    ) throws -> Calculation {
        guard gasConsumed >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: gasConsumed) }
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard minutes >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .time, value: minutes) }
        guard tank.ratedPressure >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .tankPressure, value: tank.ratedPressure) }
        guard tank.volume >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .volume, value: tank.volume) }
        let surfaceAirConsumption = try self.surfaceAirConsumption(at: depth, for: minutes, consuming: gasConsumed)
        return try self.respiratoryMinuteVolume(for: surfaceAirConsumption, with: tank)
    }
    
    /**
     Calculates the respiratory minute volume of a diver.
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
         let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 33, for: 10, startGas: 1700, endGas: 1500)
         let respiratoryMinuteVolume = try gasCalculator.respiratoryMinuteVolume(for: surfaceAirConsumption, with: tank)
         print(respiratoryMinuteVolume.round(to: 2)) // 0.27 (ft3/min)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     */
    public func respiratoryMinuteVolume(
        for surfaceAirConsumption: SurfaceAirConsumption,
        with tank: DKTank
    ) throws -> Calculation {
        // Handle Error Cases
        let tankConversionFactor = tank.volume / tank.ratedPressure
        let respiratoryMinuteVolume = surfaceAirConsumption.value * tankConversionFactor
        return Calculation.respiratoryMinuteVolume(
            value: respiratoryMinuteVolume,
            diveKit: self.diveKit
        )
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
        for minutes: Minutes,
        consuming gasConsumed: Pressure
    ) throws -> Calculation {
        guard gasConsumed >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: gasConsumed) }
        guard minutes >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .time, value: minutes) }
        let depthAirConsumption =  gasConsumed / minutes
        return Calculation.depthAirConsumption(value: depthAirConsumption, diveKit: diveKit)
    }
}

extension DKGasCalculator {
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
    @available(*, deprecated, renamed: "respiratoryMinuteVolume(at:for:with:consuming:)")
    public func respiratoryMinuteVolume( gasConsumed: Double, tank: DKTank, depth: Double, time: Double) {}
    
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
    @available(*, deprecated, renamed: "surfaceAirConsumption(at:for:consuming:)")
    public func surfaceAirConsumption(time: Double, depth: Double, gasConsumed: Double) {}
}
