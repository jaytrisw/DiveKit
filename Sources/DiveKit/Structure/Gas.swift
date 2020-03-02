//
//  Gas.swift
//  Created by Joshua Wood on 3/2/20.
//

import Foundation

public struct Gas {
    
    // MARK: - Compenent Gases Properties
    private(set) public var percentOxygen: Double = 0
    private(set) public var percentNitrogen: Double = 0
    private(set) public var percentHelium: Double = 0
    private(set) public var percentContaminantGases: Double = 0
    private(set) public var percentTraceGases: Double = 0
    
    public var pressure: Double = 1
    public var fractionVolume: Double = 1
    public var density: Double = 1
    
    public mutating func setDepth(_ depth: Double, diveKit: DiveKit) throws {
        guard depth >= 0 else {
            throw DKError(title: "Invalid Parameter", description: "Depth parameter must be a positive number")
        }
        let ata = try! DKPhysics.init(with: diveKit).atmospheresAbsolute(depth: depth)
        pressure = ata
        fractionVolume = 1 / ata
        density = ata
    }
    public func effectivePercentage(_ value: Double) -> Double {
        return value * pressure
    }
    
    // MARK: - Contaminant Properties
    private(set) public var contaminants = [String: Double]()
    public var isContaminated: Bool {
        if percentContaminantGases > 0 {
            return true
        }
        return false
    }
    
    public var partialPressure: PartialPressure {
        var partialPressure = try! PartialPressure(fractionOxygen: percentOxygen / 100, fractionNitrogen: percentNitrogen / 100, fractionHelium: percentHelium / 100, fractionContaminantGases: percentContaminantGases / 100, fractionTraceGases: percentTraceGases / 100)
        partialPressure.setPressure(self.pressure)
        return partialPressure
    }
    public var isEnrichedAir: Bool {
        if percentOxygen > 20.9 && percentHelium == 0 {
            return true
        }
        return false
    }
    
    
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
    
    static var air: Gas {
        return try! Gas(percentOxygen: 20.9, percentNitrogen: 79, percentTraceGases: 0.1)
    }
    static func enrichedAir(_ percentOxygen : Double) throws -> Gas {
        guard percentOxygen >= 0, percentOxygen <= 100 else {
            throw DKError(title: "Oxygen Percentage", description: "The percentage of oxygen must be a positive number between 0 and 100.")
        }
        let percentNitrogen = 100 - percentOxygen
        return try! Gas(percentOxygen: percentOxygen, percentNitrogen: percentNitrogen)
    }
    
    public init(percentOxygen: Double, percentNitrogen: Double) throws {
        guard percentOxygen >= 0 else {
            throw DKError(title: "Oxygen Percentage", description: "The percentage of oxygen must be a positive number.")
        }
        guard percentNitrogen >= 0 else {
            throw DKError(title: "Nitrogen Percentage", description: "The percentage of nitrogen must be a positive number.")
        }
        guard percentNitrogen + percentOxygen == 100 else {
            throw DKError(title: "Component Gas Missing", description: "The sum of the compenent gases must equal 100%.")
        }
        self.percentOxygen = percentOxygen
        self.percentNitrogen = percentNitrogen
    }
    public init(percentOxygen: Double, percentNitrogen: Double, percentTraceGases: Double) throws {
        guard percentOxygen >= 0 else {
            throw DKError(title: "Oxygen Percentage", description: "The percentage of oxygen must be a positive number.")
        }
        guard percentNitrogen >= 0 else {
            throw DKError(title: "Nitrogen Percentage", description: "The percentage of nitrogen must be a positive number.")
        }
        guard percentTraceGases >= 0 else {
            throw DKError(title: "Trace Gases Percentage", description: "The percentage of trace gases must be a positive number.")
        }
        guard percentOxygen + percentNitrogen + percentTraceGases == 100 else {
            throw DKError(title: "Component Gas Missing", description: "The sum of the compenent gases must equal 100%.")
        }
        self.percentOxygen = percentOxygen
        self.percentNitrogen = percentNitrogen
        self.percentTraceGases = percentTraceGases
    }
    public init(percentOxygen: Double, percentNitrogen: Double, percentTraceGases: Double, percentContaminantGases: Double) throws {
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
