//
//  PartialPressure.swift
//  
//
//  Created by Joshua Wood on 3/2/20.
//

import Foundation

public struct PartialPressure {
    
    private(set) public var fractionOxygen: Double = 0
    private(set) public var fractionNitrogen: Double = 0
    private(set) public var fractionHelium: Double = 0
    private(set) public var fractionContaminantGases: Double = 0
    private(set) public var fractionTraceGases: Double = 0
    
    public mutating func setPressure(_ pressure: Double) {
        fractionOxygen *= pressure
        fractionNitrogen *= pressure
        fractionHelium *= pressure
        fractionContaminantGases *= pressure
        fractionTraceGases *= pressure
    }
    
    public init(fractionOxygen: Double, fractionNitrogen: Double, fractionHelium: Double = 0, fractionContaminantGases: Double = 0, fractionTraceGases: Double = 0) throws {
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
