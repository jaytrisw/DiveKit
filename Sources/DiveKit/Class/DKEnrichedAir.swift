//  DKEnrichedAir.swift

import Foundation

/**
 A `DiveCalculator` to perform calculations involving Enriched Air Nitrox, EANx.
 - since: 1.0
 */
public final class DKEnrichedAir: DiveCalculator {
    
    /**
     Calculates the maximum operating depth of a specified gas and maximum partial pressure of oxygen.
     - parameter fractionOxygen: Double representing the maximum partial pressure of oxygen.
     - parameter gas: `Gas` representing the gas to be used for calculation.
     - returns: `Calculation` representing the maximum operating depth for specified gas and maximum partial pressure of oxygen.
     
     ### Example
     ```swift
     let enrichedAirCalculator = DKEnrichedAir.init(with: diveKit)

     do {
         let gas = try Gas.enrichedAir(32)
         // Calculate MOD for EANx32 with maximum fraction oxygen of 1.4
         let maximumOperatingDepth = try enrichedAirCalculator.maximumOperatingDepth(fractionOxygen: 1.4, gas: gas)
         print(maximumOperatingDepth.value) // 111.375
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    public func maximumOperatingDepth(
        fractionOxygen: FractionOxygen,
        gas: Gas
    ) throws -> Calculation {
        guard fractionOxygen >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .fractionOxygen, value: fractionOxygen) }
        let fractionOxygenOfBlend = gas.partialPressure.fractionOxygen
        let maximumOperatingDepth = (fractionOxygen / fractionOxygenOfBlend - 1) * diveKit.constants.oneAtmosphere
        return Calculation(value: maximumOperatingDepth, for: .maximumOperatingDepth, diveKit: diveKit)
    }
    
    /**
     Calculates the equivalent air depth of a specified gas and maximum partial pressure of oxygen.
     - parameter depth: Double representing the depth to be used for calculation.
     - parameter gas: `Gas` representing the gas to be used for calculation.
     - returns: `Calculation` representing the equivalent air depth for specified gas and depth.
     
     ### Example
     ```
     let enrichedAirCalculator = DKEnrichedAir.init(with: diveKit)

     do {
         let gas = try Gas.enrichedAir(32)
         // Calculate EAD for EANx32 at 109 feet
         let equivalentAirDepth = try enrichedAirCalculator.equivalentAirDepth(depth: 109, gas: gas)
         print(equivalentAirDepth) // 89.23
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }

     ```
     - since: 1.0
     */
    public func equivalentAirDepth(
        for depth: Depth,
        with gas: Gas
    ) throws -> Calculation {
        guard depth >= 0 else {
            throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth)
        }
        let partialPressureBlend = gas.partialPressure
        let partialPressureAir = Gas.air.partialPressure
        let depthCalc = depth + diveKit.constants.oneAtmosphere
        let nitrogenCalc = partialPressureBlend.fractionNitrogen / partialPressureAir.fractionNitrogen
        let equivalentAirDepth = depthCalc * nitrogenCalc - diveKit.constants.oneAtmosphere
        return Calculation(value: equivalentAirDepth, for: .equivalentAirDepth, diveKit: diveKit)
    }

    /**
     Calculates the best blend of enriched air, EANx, for a given fraction of oxygen and a given depth.
     - Parameters:
        - depth: Double presenting a depth.
        - fractionOxygen: Double representing the fraction of oxygen.
     - Returns: `Gas` representing the calculated best blend for the given dive.
     - Throws: DiveKit.Error
     
     ### Example
     ```
     let enrichedAirCalc = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
     do {
         // Calculate 'best blend' for to 90 feet with maximum fraction oxygen of 1.4
         let bestBlend = try enrichedAirCalc.bestBlend(for: 90, fractionOxygen: 1.4)
         print(bestBlend.percentOxygen) // 37.0 (% oxygen)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    public func bestBlend(
        for depth: Depth,
        fractionOxygen: FractionOxygen
    ) throws -> Gas {
        guard fractionOxygen > 0 else {
            throw DiveKit.Error.positiveValueRequired(parameter: .fractionOxygen, value: fractionOxygen)
        }
        guard depth > 0 else {
            throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth)
        }
        let atmospheresAbsolute = try DKPhysics.init(with: diveKit).atmospheresAbsolute(at: depth)
        let percentage = floor(fractionOxygen / atmospheresAbsolute.value * 100)
        let gas = try Gas.enrichedAir(percentage)
        return gas
    }
    
    /**
     Calculates if the specified blend of enriched air, EANx, exceeds the maximum operating depth of specified depth and maximum partial pressure of oxygen.
     - parameter fractionOxygen: Double representing the maximum partial pressure oxygen.
     - parameter depth: Double presenting a depth.
     - parameter gas: `Gas` representing the gas to be used for calculation.
     - returns: Boolean determining if depth exceeds maximum operating depth for specified `Gas`.
     
     ### Example
     ```
     let enrichedAirCalc = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)

     do {
         let gas = try Gas.enrichedAir(32)
         // Calculate if 127 feet exceeds MOD for EANx32 at maximum fraction of oxygen of 1.4
         let exceedsMod = enrichedAirCalc.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 1.4, depth: 127)
         print(exceedsMod) // true
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    public func exceedsMaximumOperatingDepth(
        with gas: Gas,
        fractionOxygen: FractionOxygen,
        depth: Depth
    ) -> Bool {
        if let maximumOperatingDepth = try? maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas) {
            if maximumOperatingDepth.value < depth {
                return true
            }
        }
        return false
    }
}

extension DKEnrichedAir {
    /**
     Calculates the maximum operating depth of a specified gas and maximum partial pressure of oxygen.
     - parameter fractionOxygen: Double representing the maximum partial pressure of oxygen.
     - parameter gas: `Gas` representing the gas to be used for calculation.
     - parameter decimalPlaces: Integer representing the desired number of decimal places to return.
     - returns: Double representing the maximum operating depth for specified gas and maximum partial pressure of oxygen.
     
     ### Example
     ```swift
     let enrichedAirCalc = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
     let gas = DKGas.enrichedAir(percentage: 32)
     do {
         // Calculate MOD for EANx32 with maximum fraction oxygen of 1.4
         let mod = try enrichedAirCalc.maximumOperatingDepth(fractionOxygen: 1.4, gas: gas)
         print(mod) // 111 (feet)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    @available(*, deprecated, renamed: "maximumOperatingDepth(fractionOxygen:gas:)")
    public func maximumOperatingDepth(
        fractionOxygen: FractionOxygen,
        gas: Gas,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard fractionOxygen >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .fractionOxygen, value: fractionOxygen) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas).round(to: decimalPlaces)
    }
    /**
     Calculates the equivalent air depth of a specified gas and maximum partial pressure of oxygen.
     - parameter depth: Double representing the depth to be used for calculation.
     - parameter gas: `DKGas` representing the gas to be used for calculation.
     - parameter decimalPlaces: Integer representing the desired number of decimal places to return.
     - returns: Double representing the equivalent air depth for specified gas and depth.
     
     ### Example
     ```
     let enrichedAirCalc = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
     let gas  = DKGas.enrichedAir(percentage: 32)
     do {
         // Calculate EAD for EANx32 at 109 feet
         let ead = try enrichedAirCalc.equivalentAirDepth(depth: 109, gas: gas)
         print(ead) // 89 (feet)
     } catch {
         // Handle Error
         print(error.localizedDescription)
     }
     ```
     - since: 1.0
     */
    @available(*, deprecated, renamed: "equivalentAirDepth(for:with:)")
    public func equivalentAirDepth(
        depth: Depth,
        gas: Gas,
        decimalPlaces: Int = 2
    ) throws -> Double {
        guard depth >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .depth, value: depth) }
        guard decimalPlaces >= 0 else { throw DiveKit.Error.positiveValueRequired(parameter: .decimalPlaces, value: Double(decimalPlaces)) }
        return try equivalentAirDepth(for: depth, with: gas).round(to: decimalPlaces)
    }
}
