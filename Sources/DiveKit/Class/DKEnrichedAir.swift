//  DKEnrichedAir.swift

import Foundation

/// Object to perform calculations involving Enriched Air Nitrox or EANx.
public class DKEnrichedAir {
    
    // MARK: - Instance Properties
    private(set) var diveKit: DiveKit!
    
    // MARK: - Calculation Methods
    /**
     Calculates the maximum operating depth of a specified gas and maximum partial pressure of oxygen.
     - parameter fractionOxygen: Double representing the maximum partial pressure of oxygen.
     - parameter gas: `Gas` representing the gas to be used for calculation.
     - parameter decimalPlaces: Integer representing the desired number of decimal places to return.
     - returns: Double representing the maximum operating depth for specified gas and maximum partial pressure of oxygen.
     
     ### Definition
     The maximum operating depth (MOD) of breathing gas is the depth below which the partial pressure of oxygen of the gas mix exceeds an acceptable limit. This limit is based on the risk of central nervous system oxygen toxicity, and is somewhat arbitrary, and varies depending on the diver training agency or Code of Practice, the level of underwater exertion planned and the planned duration of the dive, but is normally in the range of 1.2 to 1.6 bar.
     
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
    public func maximumOperatingDepth(
        fractionOxygen: Double,
        gas: Gas,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard fractionOxygen >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Fraction of oxygen parameter must be greater than 0")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be greater than 0")
        }
        // Calculate partial pressure of oxygen in gas
        // MOD =  { (Partial Pressure / Fraction of O2) - 1 } x 33 feet
        let fractionOxygenOfBlend = gas.partialPressure.fractionOxygen
        let temp = fractionOxygen / fractionOxygenOfBlend - 1
        switch diveKit.measurementUnit {
        case .imperial:
            switch diveKit.waterType {
            case .saltWater:
                return floor(temp * DKConstants.imperial.oneAtmosphere.saltWater)
            case .freshWater:
                return floor(temp * DKConstants.imperial.oneAtmosphere.freshWater)
            }
        case .metric:
            switch diveKit.waterType {
            case .saltWater:
                return (temp * DKConstants.metric.oneAtmosphere.saltWater).roundTo(decimalPlaces: decimalPlaces)
            case .freshWater:
                return (temp * DKConstants.metric.oneAtmosphere.freshWater).roundTo(decimalPlaces: decimalPlaces)
            }
        }
    }
    /**
     Calculates the equivalent air depth of a specified gas and maximum partial pressure of oxygen.
     - parameter depth: Double representing the depth to be used for calculation.
     - parameter gas: `DKGas` representing the gas to be used for calculation.
     - parameter decimalPlaces: Integer representing the desired number of decimal places to return.
     - returns: Double representing the equivalent air depth for specified gas and depth.
     
     ### Definition
     Equivalent air depth (EAD) is a way of approximating the decompression requirements of breathing gas mixtures that contain nitrogen and oxygen in different proportions to those in air. The equivalent air depth, for a given gas and depth, is the depth of a dive when breathing air that would have the same partial pressure of nitrogen.
     
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
    public func equivalentAirDepth(
        depth: Double,
        gas: Gas,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be greater than 0")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be greater than 0")
        }
        // EAD = (Depth + 33) × Fraction of N2 / 0.79 − 33
        let partialPressureBlend = gas.partialPressure
        let partialPressureAir = Gas.air.partialPressure
        switch diveKit.measurementUnit {
        case .imperial:
            let oneAtmosphere = DKConstants.imperial.oneAtmosphere
            switch diveKit.waterType {
            case .saltWater:
                let depthCalc = depth + oneAtmosphere.saltWater
                let nitrogenCalc = partialPressureBlend.fractionNitrogen / partialPressureAir.fractionNitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.saltWater).roundTo(decimalPlaces: decimalPlaces)
            case .freshWater:
                let depthCalc = depth + oneAtmosphere.freshWater
                let nitrogenCalc = partialPressureBlend.fractionNitrogen / partialPressureAir.fractionNitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.freshWater).roundTo(decimalPlaces: decimalPlaces)
            }
        case .metric:
            let oneAtmosphere = DKConstants.metric.oneAtmosphere
            switch diveKit.waterType {
            case .saltWater:
                let depthCalc = depth + oneAtmosphere.saltWater
                let nitrogenCalc = partialPressureBlend.fractionNitrogen / partialPressureAir.fractionNitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.saltWater).roundTo(decimalPlaces: decimalPlaces)
            case .freshWater:
                let depthCalc = depth + oneAtmosphere.freshWater
                let nitrogenCalc = partialPressureBlend.fractionNitrogen / partialPressureAir.fractionNitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.freshWater).roundTo(decimalPlaces: decimalPlaces)
            }
        }
    }
    
    /**
     Calculates the best blend of nitrox, EANx, for a given fraction of oxygen and a given depth.
     - parameter depth: Double presenting a depth.
     - parameter fractionOxygen: Double prepresenting the fraction of oxygen.
     - returns: `Gas` representing the calculated best blend for the given dive.
     
     ### Definition
     The "best blend" for the dive provides the maximum no-decompression time compatible with acceptable oxygen exposure. An acceptable maximum partial pressure of oxygen is selected based on depth and planned bottom time, and this value is used to calculate the oxygen content of the best mix for the dive.
     
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
        for depth: Double,
        fractionOxygen: Double
    ) throws -> Gas {
        guard fractionOxygen > 0 else {
            throw DKError.partialPressureNeedsPositive
        }
        guard depth > 0 else {
            throw DKError.depthNeedsPositive
        }
        let ata = try! DKPhysics.init(with: diveKit).atmospheresAbsolute(depth: depth)
        let percentage = floor(fractionOxygen / ata * 100)
        var gas = try! Gas.enrichedAir(percentage)
        if try! exceedsMaximumOperatingDepth(with: gas, fractionOxygen: fractionOxygen, depth: depth) {
            let integerPercent = Int(percentage)
            for i in (integerPercent..<100) {
                gas = try! Gas.enrichedAir(Double(i))
                if try! !exceedsMaximumOperatingDepth(with: gas, fractionOxygen: fractionOxygen, depth: depth) {
                    return gas
                }
            }
        }
        return gas
    }
    
    /**
     Calculates if the specified blend of nitrox, EANx, exceeds the maximum operating depth of specified depth and maximum partial pressure of oxygen.
     - parameter fractionOxygen: Double representing the fraction of oxygen.
     - parameter depth: Double presenting a depth.
     - parameter gas: `Gas` representing the gas to be used for calculation.
     - returns: Boolean determining if depth exceeds maximum operating depth for specified `DKGas`.
     
     ### Example
     ```
     let enrichedAirCalc = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
     let gas  = DKGas.enrichedAir(percentage: 32)
     do {
         // Calculate if 127 feet exceeds MOD for EANx32 at maximum fraction of oxygen of 1.4
         let exceedsMod = try enrichedAirCalc.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 1.4, depth: 127)
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
        fractionOxygen: Double,
        depth: Double
    ) throws -> Bool {
        guard fractionOxygen >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Fraction of oxygen parameter must be greater than 0")
        }
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be greater than 0")
        }
        let mod = try! maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas, decimalPlaces: 10)
        if mod < depth {
            return true
        }
        return false
    }
    
    // MARK: - Initializers
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with default values of `DiveKit.WaterType.saltWater` and `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public init() {
        diveKit = DiveKit()
    }
    /**
     Initializes a `DKEnrichedAir` object with a `DiveKit` object.
     - since: 1.0
     */
    public convenience init(with diveKit: DiveKit) {
        self.init()
        self.diveKit = diveKit
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with values for `DiveKit.WaterType` and `DiveKit.MeasurementUnit`
     - parameter waterType: `DiveKit.WaterType`
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType, measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(waterType: waterType, measurementUnit: measurementUnit)
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with value for `DiveKit.WaterType` and default value of `DiveKit.MeasurementUnit.imperial`
     - parameter waterType: `DiveKit.WaterType`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType) {
        self.init()
        diveKit = DiveKit(waterType: waterType)
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with value for `DiveKit.MeasurementUnit` and default value of `DiveKit.WaterType.saltWater`
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 1.0
     */
    public convenience init(measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(measurementUnit: measurementUnit)
    }
}
