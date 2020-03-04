//
//  Gas.swift
//  Created by Joshua Wood on 3/2/20.
//

import Foundation

/**
 An object that represents a scuba diving breathing gas.
 - since: 1.0
 */
public struct Gas {
    
    // MARK: - Component Gases Properties
    /// Percentage of oxygen in gas blend.
    private(set) public var percentOxygen: Double = 0
    /// Percentage of nitrogen in gas blend.
    private(set) public var percentNitrogen: Double = 0
    /// Percentage of helium in gas blend, not currently avaiable though any initializers.
    private(set) public var percentHelium: Double = 0
    /// Percentage of contaminant gases in gas blend
    private(set) public var percentContaminantGases: Double = 0
    /// Percentage of trace gases in gas blend
    private(set) public var percentTraceGases: Double = 0
    
    // MARK: - Pressure/Volume/Density Properties
    /// Current absolute pressure on gas.
    public var pressure: Double = 1
    /// Current fractional volume of gas.
    public var fractionVolume: Double = 1
    ///Current density of gas.
    public var density: Double = 1
    
    // MARK: - Partial Pressure Property
    /// A `PartialPressure` object that holds the current partial pressures of the gases constituent gas.
    public var partialPressure: PartialPressure {
        var partialPressure = try! PartialPressure(fractionOxygen: percentOxygen / 100, fractionNitrogen: percentNitrogen / 100, fractionHelium: percentHelium / 100, fractionContaminantGases: percentContaminantGases / 100, fractionTraceGases: percentTraceGases / 100)
        partialPressure.setPressure(self.pressure)
        return partialPressure
    }
    
    // MARK: - Contaminant Properties and Methods
    /// Property that holds a String representing a contaminant and Double representing percentage of the contaminant
    private(set) public var contaminants = [String: Double]()
    /// A Boolean value indicating whether the gas has any gaseous contaminants.
    public var isContaminated: Bool {
        if percentContaminantGases > 0 {
            return true
        }
        return false
    }
    
    // MARK: - Methods
    /**
     Sets contaminant and its percentage.
     - parameter contaminants: [String: Double] where String represents a contaminant and Double represents percentage of the contaminant.
     
     - since: 1.0
     */
    public mutating func setContaminants(_ contaminants: [String: Double]) throws {
        var totalPercentage: Double = 0
        contaminants.forEach { (contaminant, percentage) in
            totalPercentage += percentage
        }
        guard percentContaminantGases == totalPercentage else {
            throw DKError(title: "Contaminant Gases Percentage", description: "The sum of the contaminants set does not match the percentage of contaminant gases for this gas blend.")
        }
        self.contaminants = contaminants
    }
    
    // MARK: - Enriched Air Properties
    /// A Boolean value indicating whether the gas contains a percentage of oxygen high that 20.9%.
    public var isEnrichedAir: Bool {
        if percentOxygen > 20.9 && percentHelium == 0 {
            return true
        }
        return false
    }
    
    // MARK: - Methods
    /**
     Sets the pressure, volume and density properties to specified depth.
     - parameter depth: Double representing a specified depth.
     - parameter diveKit: `DiveKit` object used to perform calculations.
     
     - since: 1.0
     */
    public mutating func setDepth(_ depth: Double, diveKit: DiveKit) throws {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be a positive number")
        }
        let ata = try! DKPhysics.init(with: diveKit).atmospheresAbsolute(depth: depth)
        pressure = ata
        fractionVolume = 1 / ata
        density = ata
    }
    /**
     Calculates what the effective percentage of a component gas when breathed at a pressure greater than surface pressure.
     - parameter value: Double representing the component gas to perform calculation on.
     - returns: Double representing the effective percentage of a component gas when breathed at a pressure greater than surface pressure.
     
     #### Example
     ```
     do {
     var gas = try Gas.init(percentOxygen: 20.8, percentNitrogen: 79, percentTraceGases: 0.1, percentContaminantGases: 0.1)
     try gas.setDepth(99, diveKit: DiveKit.init())
     
     let effectivePercent = gas.effectivePercentage(gas.percentContaminantGases)
     print(effectivePercent) // 0.4 (%)
     } catch {
     // Handle Error
     print(error.localizedDescription)
     }
     ```
     
     - since: 1.0
     */
    public func effectivePercentage(_ value: Double) -> Double {
        return value * pressure
    }
    
    // MARK: - Static Instances
    /**
     A singleton gas object prepresenting compressed air.
     
     - since: 1.0
     */
    public static var air: Gas {
        return try! Gas(percentOxygen: 20.9, percentNitrogen: 79, percentTraceGases: 0.1)
    }
    /**
     A singleton gas object prepresenting enriched air blend of a specified percentage of oxygen.
     - parameter percentOxygen: Double representing the percentage of oxygen in gad blend, value must be a positive number less than 100.
     
     - since: 1.0
     */
    public static func enrichedAir(_ percentOxygen : Double) throws -> Gas {
        guard percentOxygen >= 0, percentOxygen <= 100 else {
            throw DKError(title: "Oxygen Percentage", description: "The percentage of oxygen must be a positive number between 0 and 100.")
        }
        let percentNitrogen = 100 - percentOxygen
        return try! Gas(percentOxygen: percentOxygen, percentNitrogen: percentNitrogen)
    }
    
    // MARK: - Initializer
    /**
     Initializes a `Gas` object.
     - parameter percentOxygen: Double representing the percentage of oxygen in the gas blend, the value must be a positive number less than 100.
     - parameter percentNitrogen: Double representing the percentage of nitrogen in the gas blend, the value must be a positive number less than 100.
     - parameter percentContaminantGases: Double representing the percentage of contaminant gases in the gas blend, the value must be a positive number less than 100.
     - parameter percentTraceGases: Double representing the percentage of trace gases in the gas blend, the value must be a positive number less than 100.
     
     - since: 1.0
     */
    public init(
        percentOxygen: Double,
        percentNitrogen: Double,
        percentTraceGases: Double = 0,
        percentContaminantGases: Double = 0) throws {
        guard percentOxygen >= 0 else {
            throw DKError(title: "Oxygen Percentage", description: "The percentage of oxygen must be a positive number.")
        }
        guard percentNitrogen >= 0 else {
            throw DKError(title: "Nitrogen Percentage", description: "The percentage of nitrogen must be a positive number.")
        }
        guard percentTraceGases >= 0 else {
            throw DKError(title: "Trace Gases Percentage", description: "The percentage of trace gases must be a positive number.")
        }
        guard percentContaminantGases >= 0 else {
            throw DKError(title: "Contaminant Gases Percentage", description: "The percentage of contaminant gases must be a positive number.")
        }
        guard percentOxygen + percentNitrogen + percentTraceGases + percentContaminantGases == 100 else {
            throw DKError(title: "Component Gas Missing", description: "The sum of the compenent gases must equal 100%.")
        }
        self.percentOxygen = percentOxygen
        self.percentNitrogen = percentNitrogen
        self.percentTraceGases = percentTraceGases
        self.percentContaminantGases = percentContaminantGases
    }
}
