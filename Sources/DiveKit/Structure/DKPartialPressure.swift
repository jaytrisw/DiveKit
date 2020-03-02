//  DKPartialPressure.swift

import Foundation

/// An object that contains values for the partial pressures of the components of diving gases.
public struct DKPartialPressure {
    var oxygen: Double = 0
    var nitrogen: Double = 0
    var trace: Double = 0
    
    public init(oxygen: Double, nitrogen: Double, trace: Double) {
        self.oxygen = oxygen
        self.nitrogen = nitrogen
        self.trace = trace
    }
}
