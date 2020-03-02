//  DKPartialPressure.swift

import Foundation

/// An object that contains values for the partial pressures of the components of diving gases.
public struct DKPartialPressure {
    /// Fraction of oxygen
    var oxygen: Double = 0
    /// Fraction of nitrogen
    var nitrogen: Double = 0
    /// Fraction of trace gases
    var trace: Double = 0
    
    /**
    Initializes `DKPartialPressure` with the specified values.
     - parameter oxygen: Double representing the fraction of oxygen.
     - parameter nitrogen: Double representing the fraction of nitrogen.
     - parameter trace: Double representing the fraction of trace gases.
    - since: 1.0
    */
    public init(oxygen: Double, nitrogen: Double, trace: Double) {
        self.oxygen = oxygen
        self.nitrogen = nitrogen
        self.trace = trace
    }
}
