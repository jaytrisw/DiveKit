//
//  PartialPressure.swift
//  
//
//  Created by Joshua Wood on 3/2/20.
//

import Foundation

/**
 An object that contains values for the partial pressures of the components of a specific diving gas.
 
 - since: 1.0
 */
public struct PartialPressure {
    /// Fraction of oxygen
    private(set) public var fractionOxygen: Double = 0
    /// Fraction of nitrogen
    private(set) public var fractionNitrogen: Double = 0
    /// Fraction of helium
    private(set) public var fractionHelium: Double = 0
    /// Fraction of contaminant gases
    private(set) public var fractionContaminantGases: Double = 0
    /// Fraction of trace gases
    private(set) public var fractionTraceGases: Double = 0
    
    /**
    Sets contaminant and its percentage.
    - parameter pressure: Double representing the pressure to calculate properties to.
    
    - since: 1.0
    */
    internal mutating func setPressure(_ pressure: Double) {
        fractionOxygen *= pressure
        fractionNitrogen *= pressure
        fractionHelium *= pressure
        fractionContaminantGases *= pressure
        fractionTraceGases *= pressure
    }
    
    // MARK: - Initializer
    /**
     Initializes a `PartialPressure` object.
     - parameter percentOxygen: Double representing the percentage of oxygen in the gas blend, the value must be a positive number less than 100.
     - parameter percentNitrogen: Double representing the percentage of nitrogen in the gas blend, the value must be a positive number less than 100.
     - parameter fractionHelium: Double representing the percentage of helium in the gas blend, the value must be a positive number less than 100.
     - parameter percentContaminantGases: Double representing the percentage of contaminant gases in the gas blend, the value must be a positive number less than 100.
     - parameter percentTraceGases: Double representing the percentage of trace gases in the gas blend, the value must be a positive number less than 100.
     
     ### Definition
     In a mixture of gases, each constituent gas has a partial pressure which is the notional pressure of that constituent gas if it alone occupied the entire volume of the original mixture at the same temperature. The total pressure of an ideal gas mixture is the sum of the partial pressures of the gases in the mixture.
     
     - since: 1.0
     */
    internal init(
        fractionOxygen: Double,
        fractionNitrogen: Double,
        fractionHelium: Double = 0,
        fractionContaminantGases: Double = 0,
        fractionTraceGases: Double = 0
    ) throws {
        guard fractionOxygen >= 0, fractionOxygen <= 1 else {
            throw DKError(title: "Fraction of Oxygen", description: "The fraction of oxygen must be a positive number between 0 and 1, not \(fractionOxygen).")
        }
        guard fractionNitrogen >= 0, fractionNitrogen <= 1 else {
            throw DKError(title: "Fraction of Nitrogen", description: "The fraction of nitrogen must be a positive number between 0 and 1, not \(fractionNitrogen).")
        }
        guard fractionHelium >= 0, fractionHelium <= 1 else {
            throw DKError(title: "Fraction of Helium", description: "The fraction of helium must be a positive number between 0 and 1, not \(fractionHelium).")
        }
        guard fractionContaminantGases >= 0, fractionContaminantGases <= 1 else {
            throw DKError(title: "Fraction of Contaminant Gases", description: "The fraction of contaminant gases must be a positive number between 0 and 1, not \(fractionContaminantGases).")
        }
        guard fractionTraceGases >= 0, fractionTraceGases <= 1 else {
            throw DKError(title: "Fraction of Trace Gases", description: "The fraction of trace gases must be a positive number between 0 and 1, not \(fractionTraceGases).")
        }
        guard fractionOxygen + fractionNitrogen + fractionHelium + fractionContaminantGases + fractionTraceGases == 1 else {
            throw DKError(title: "Component Gas Missing", description: "The sum of the compenent gases must equal 1.")
        }
        self.fractionOxygen = fractionOxygen
        self.fractionNitrogen = fractionNitrogen
        self.fractionHelium = fractionHelium
        self.fractionContaminantGases = fractionContaminantGases
        self.fractionTraceGases = fractionTraceGases
    }
}
