//  DKEnrichedAir.swift

import Foundation

/// Object to perform calculations involving Enriched Air Nitrox or EANx.
public class DKEnrichedAir {
    
    // MARK: - Instance Properties
    private(set) var diveKit: DiveKit!
    
    // MARK: - Calculation Methods
    /**
     Calculates the maximum operating depth of a specified gas and maximum partial presure of oxygen.
     - parameter fractionOxygen: Double representing the maximum partial presure of oxygen.
     - parameter gas: `DKGas` representing the gas to be used for calculation.
     - parameter accuracy: Integer representing the dersired number of decimal place to return.
     - returns: Double representing the maximum operating depth for specified gas and maximum partial pressure of oxygen.
     
     ### Definition
     The maximum operating depth (MOD) of a breathing gas is the depth below which the partial pressure of oxygen of the gas mix exceeds an acceptable limit. This limit is based on risk of central nervous system oxygen toxicity, and is somewhat arbitrary, and varies depending on the diver training agency or Code of Practice, the level of underwater exertion planned and the planned duration of the dive, but is normally in the range of 1.2 to 1.6 bar.
     
     ### Example
     ```
     // Calculate MOD for EANx32 with imperial units in saltwater
     let diveKit = DiveKit.init()
     let enrichedAir = DKEnrichedAir.init(with: diveKit)
     let gas = DKGas.enrichedAir(percentage: 32)
     let mod = enrichedAir.maximumOperatingDepth(fractionOxygen: 1.4, gas: gas)
     print(mod) // 111
     ```
     - since: 0.9
     */
    public func maximumOperatingDepth(
        fractionOxygen: Double,
        gas: DKGas,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard fractionOxygen >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Fraction of oxygen parameter must be greater than 0")
        }
        guard gas.percentOxygen >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Percentage of oxygen must be greater than 0")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be greater than 0")
        }
        // Calculate partial pressure of oxygen in gas
        // MOD =  { (Partial Pressure / Fraction of O2) - 1 } x 33 feet
        let fractionOxygenOfBlend = DKGasCalculator(with: diveKit).partialPressure(of: gas)
        let temp = fractionOxygen / fractionOxygenOfBlend.oxygen - 1
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
     Calculates the equivalent air depth of a specified gas and maximum partial presure of oxygen.
     - parameter depth: Double representing the depth to be used for calculation.
     - parameter gas: `DKGas` representing the gas to be used for calculation.
     - parameter accuracy: Integer representing the dersired number of decimal place to return.
     - returns: Double representing the equivalent air depth for specified gas and depth.
     
     ### Definition
     Equivalent air depth (EAD) is a way of approximating the decompression requirements of breathing gas mixtures that contain nitrogen and oxygen in different proportions to those in air. The equivalent air depth, for a given gas and depth, is the depth of a dive when breathing air that would have the same partial pressure of nitrogen.
     
     ### Example
     ```
     // Calculate EAD for EANx36 with imperial units in saltwater
     let diveKit = DiveKit.init()
     let enrichedAir = DKEnrichedAir.init(with: diveKit)
     let gas = DKGas.enrichedAir(percentage: 36)
     let ead = enrichedAir.equivalentAirDepth(depth: 89, gas: gas)
     print(ead) // 66
     ```
     - since: 0.9
     */
    public func equivalentAirDepth(
        depth: Double,
        gas: DKGas,
        decimalPlaces: Int = 0
    ) throws -> Double {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be greater than 0")
        }
        guard gas.percentOxygen >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Percentage of oxygen must be greater than 0")
        }
        guard decimalPlaces >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Decimal places parameter must be greater than 0")
        }
        // EAD = (Depth + 33) × Fraction of N2 / 0.79 − 33
        let partialPressureBlend = DKGasCalculator(with: diveKit).partialPressure(of: gas)
        let partialPressureAir = DKGasCalculator(with: diveKit).partialPressure(of: .air)
        switch diveKit.measurementUnit {
        case .imperial:
            let oneAtmosphere = DKConstants.imperial.oneAtmosphere
            switch diveKit.waterType {
            case .saltWater:
                let depthCalc = depth + oneAtmosphere.saltWater
                let nitrogenCalc = partialPressureBlend.nitrogen / partialPressureAir.nitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.saltWater).roundTo(decimalPlaces: decimalPlaces)
            case .freshWater:
                let depthCalc = depth + oneAtmosphere.freshWater
                let nitrogenCalc = partialPressureBlend.nitrogen / partialPressureAir.nitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.freshWater).roundTo(decimalPlaces: decimalPlaces)
            }
        case .metric:
            let oneAtmosphere = DKConstants.metric.oneAtmosphere
            switch diveKit.waterType {
            case .saltWater:
                let depthCalc = depth + oneAtmosphere.saltWater
                let nitrogenCalc = partialPressureBlend.nitrogen / partialPressureAir.nitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.saltWater).roundTo(decimalPlaces: decimalPlaces)
            case .freshWater:
                let depthCalc = depth + oneAtmosphere.freshWater
                let nitrogenCalc = partialPressureBlend.nitrogen / partialPressureAir.nitrogen
                return (depthCalc * nitrogenCalc - oneAtmosphere.freshWater).roundTo(decimalPlaces: decimalPlaces)
            }
        }
    }
    
    /**
     Calculates the best blend of nitrox, EANx, for a given fraction of oxygen and a given depth.
     - parameter depth: Double presenting a depth.
     - parameter fractionOxygen: Double prepresenting the fraction of oxygen.
     - returns: `DKGas` representing the calculated best blend for the given dive.
     
     ### Definition
     The "best blend" for the dive provides the maximum no-decompression time compatible with acceptable oxygen exposure. An acceptable maximum partial pressure of oxygen is selected based on depth and planned bottom time, and this value is used to calculate the oxygen content of the best mix for the dive.
     
     ### Example
     ```
     let enrichedAir = DKEnrichedAir.init()
     do {
     let blend = try enrichedAir.bestBlend(for: 1.4, to: 100)
     print(blend) // DKGas.enrichedAir(percentage: 35)
     } catch {
     print(error.localizedDescription)
     // Handle potential error
     }
     ```
     - since: 0.9
     */
    public func bestBlend(for depth: Double,
                          fractionOxygen: Double) throws -> DKGas {
        guard fractionOxygen > 0 else {
            throw DKError.partialPressureNeedsPositive
        }
        guard depth > 0 else {
            throw DKError.depthNeedsPositive
        }
        do {
            let ata = try DKPhysics.init(with: diveKit).atmospheresAbsolute(depth: depth)
            let percentage = floor(fractionOxygen / ata * 100)
            var gas = DKGas.enrichedAir(percentage: percentage)
            if try exceedsMaximumOperatingDepth(with: gas, fractionOxygen: fractionOxygen, depth: depth) {
                let integerPercent = Int(percentage)
                for i in (integerPercent..<100) {
                    gas = DKGas.enrichedAir(percentage: Double(i))
                    if try !exceedsMaximumOperatingDepth(with: gas, fractionOxygen: fractionOxygen, depth: depth) {
                        return gas
                    }
                }
            }
            return gas
        } catch {
            throw error
        }
        
    }
    
    /**
     Calculates if the specified blend of nitrox, EANx, exceed the maximum operating depth of specified depth and maximum partial pressure of oxygen.
     - parameter fractionOxygen: Double prepresenting the fraction of oxygen.
     - parameter depth: Double presenting a depth.
     - parameter gas: `DKGas` representing the gas to be used for calculation.
     - returns: Boolean detemining if depth exceeds maximum operating depth for specified `DKGas`.
     
     ### Example
     ```
     let enrichedAir = DKEnrichedAir.init()
     let gas = DKGas.enrichedAir(percentage: 36)
     let exceedsMOD = enrichedAir.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 1.4, depth: 130)
     print(exceedsMOD) // true
     ```
     - since: 0.9
     */
    public func exceedsMaximumOperatingDepth(
        with gas: DKGas,
        fractionOxygen: Double,
        depth: Double
    ) throws -> Bool {
        guard fractionOxygen >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Fraction of oxygen parameter must be greater than 0")
        }
        guard gas.percentOxygen >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Percentage of oxygen must be greater than 0")
        }
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be greater than 0")
        }
        do {
            let mod = try maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas, decimalPlaces: 10)
            if mod > depth {
                print(mod, ">",  depth)
                return true
            }
            return false
        } catch {
            throw error
        }
        
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
     - parameter waterType: `DiveKit.WaterType`
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType, measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(waterType: waterType, measurementUnit: measurementUnit)
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with value for `DiveKit.WaterType` and default value of `DiveKit.MeasurementUnit.imperial`
     - parameter waterType: `DiveKit.WaterType`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType) {
        self.init()
        diveKit = DiveKit(waterType: waterType)
    }
    /**
     Initializes `DKEnrichedAir` and `DiveKit` objects with value for `DiveKit.MeasurementUnit` and default value of `DiveKit.WaterType.saltWater`
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 0.9
     */
    public convenience init(measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        diveKit = DiveKit(measurementUnit: measurementUnit)
    }
}
