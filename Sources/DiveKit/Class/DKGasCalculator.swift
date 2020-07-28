//  DKGasCalculator.swift

/**
 A `DiveCalculator`  used to perform gas calculations.
 - since: 1.0
 */
public final class DKGasCalculator: DiveCalculator {
    /**
     Calculates the partial pressure of a gas at sea-level or a specified depth.
     
     - parameter gas: `Gas` to calculate the partial pressure.
     - parameter depth: Double presenting a depth, defaults to sea level.
     - returns: `PartialPressure` of constituent gases in input `Gas` at surface pressure or input depth
     
     # Example #
     ```
     let diveKit = DiveKit.default
     let gasCalculator = DKGasCalculator(with: diveKit)

     do {
         // Calculate partial pressure of component gases in EANx32 at 99 feet.
         let gas = try Gas.enrichedAir(32)
         let partialPressure = try gasCalculator.partialPressure(of: gas, at: 99)
         print(partialPressure) // PartialPressure(oxygen: 1.28, nitrogen: 2.72, trace: 0.0)
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
    
    /**
     Calculates surface air consumption of a diver
     
     - parameter depth: Double representing the depth expressed in feet or meters that the calculation was performed.
     - parameter minutes: Double representing the time expressed in minutes that the calculation was performed.
     - parameter gasConsumed: Double representing the amount of gas consumed expressed in psi or bar per minute during the calculation.
     - returns: `Calculation` representing the consumed psi or bar per minute calculated for surface pressure.
     - throws: `DiveKit.Error`
     - since: 1.0
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()

     do {
         // Calculate SAC rate
         let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 33, for: 10, consuming: 200)
         print(surfaceAirConsumption.value) // 10.0
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     */
    public func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        consuming gasConsumed: Pressure
    ) throws -> Calculation {
        guard gasConsumed >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: gasConsumed) }
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard minutes >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .time, value: minutes) }
        let atmospheresAbsolute = try DKPhysics(with: diveKit).atmospheresAbsolute(at: depth)
        let depthAirConsumption = try self.depthAirConsumption(for: minutes, consuming: gasConsumed)
        let surfaceAirConsumption = depthAirConsumption.value / atmospheresAbsolute.value
        return Calculation(
            value: surfaceAirConsumption,
            for: .surfaceAirConsumption,
            diveKit: self.diveKit
        )
    }
    
    /**
     Calculates surface air consumption of a diver
     
     - parameter depth: Double representing the depth expressed in feet or meters that the calculation was performed.
     - parameter minutes: Double representing the time expressed in minutes that the calculation was performed.
     - parameter startGas: Double representing the gas pressure at the beginning of calculation.
     - parameter endGas:  Double representing the gas pressure at the end of calculation.
     - returns: `Calculation` representing the consumed psi or bar per minute calculated for surface pressure.
     - throws: `DiveKit.Error`
     - since: 1.0
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()

     do {
         // Calculate SAC rate
         let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 33, for: 10, startGas: 2400, endGas: 2200)
         print(surfaceAirConsumption.value) // 10.0
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     */
    public func surfaceAirConsumption(
        at depth: Depth,
        for minutes: Minutes,
        startGas: Pressure,
        endGas: Pressure
    ) throws -> Calculation {
        guard startGas >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: startGas) }
        guard endGas >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .gasConsumed, value: endGas) }
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard minutes >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .time, value: minutes) }
        let gasConsumed = startGas - endGas
        return try surfaceAirConsumption(
            at: depth,
            for: minutes,
            consuming: gasConsumed
        )
    }
    
    /**
     Calculates the respiratory minute volume of a diver.
     - parameter depth: Double, representing the depth, expressed in feet or meters, that this calculation was performed.
     - parameter time: Double, representing the length of time, expressed in minutes, that this calculation was performed.
     - parameter tank: `DKTank`, representing the tank used when this calculation was performed, expressed in psi or bar.
     - parameter gasConsumed: Double, representing the amount of air that was consumed during this calculation, expressed in psi or bar
     - returns: `Calculation`, representing the consumed volume of air per minute express in cubic feet per minute or liters per minute calculated for surface pressure.
     - throws: `DiveKit.Error`
     - since: 1.0
     
     #### Example
     ```
     let gasCalculator = DKGasCalculator.init()

     do {
         // Calculate RMV Rate
         let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
         let respiratoryMinuteVolume = try gasCalculator.respiratoryMinuteVolume(at: 33, for: 10, with: tank, consuming: 200)
         print(respiratoryMinuteVolume.round(to: 2)) // 0.27 (ft3/min)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }

     ```
     */
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
     - parameter surfaceAirConsumption: `Calculation`, representing the surface air consumption to use for calculation of respiratory minute volume.
     - parameter tank: `DKTank`, representing the tank used when this calculation was performed, expressed in psi or bar.
     - returns: `Calculation`, representing the consumed volume of air per minute express in cubic feet per minute or liters per minute calculated for surface pressure.
     - throws: `DiveKit.Error`
     - since: 1.0
     
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
        return Calculation(
            value: respiratoryMinuteVolume,
            for: .respiratoryMinuteVolume,
            diveKit: self.diveKit
        )
    }
        
    /**
     Calculates air consumption of a diver at depth
     
     - parameter minutes: Double representing the time expressed in minutes that the calculation was performed.
     - parameter gasConsumed: Double representing the amount of gas consumed expressed in psi or bar per minute during the calculation.
     - returns: `Calculation` representing the consumed psi or bar per minute calculated for ambient pressure.
     - throws: `DiveKit.Error`
     
     # Example #
     ```
     let gasCalculator = DKGasCalculator.init()
     do {
         // Calculate DAC rate
         let depthAirConsumption = try gasCalculator.depthAirConsumption(for: 10, consuming: 200)
         print(depthAirConsumption) // 20.0
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
        return Calculation(value: depthAirConsumption, for: .depthAirConsumption, diveKit: diveKit)
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
    public func respiratoryMinuteVolume(gasConsumed: Double, tank: DKTank, depth: Double, time: Double) throws -> Double {
        return try respiratoryMinuteVolume(at: depth, for: time, with: tank, consuming: gasConsumed).value
    }
    
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
    public func surfaceAirConsumption(time: Double, depth: Double, gasConsumed: Double) throws -> Double {
        return try surfaceAirConsumption(at: depth, for: time, consuming: gasConsumed).value
    }
}
