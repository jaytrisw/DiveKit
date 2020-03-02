//  DKTank.swift

import Foundation

/**
An object that represents a scuba diving cylinder.
- since: 1.0
*/
public struct DKTank {
    /**
    The type of scuba diving cylinder.
    - since: 1.0
    */
    public enum DKTankType {
        /// Standard aluminum cylinder is neutrally buoyant when at rated fill pressure.
        case aluminumStandard
        /// Compact aluminum cylinder is neutrally buoyant when empty.
        case aluminumCompact
        /// Steel cylinder
        case steel
    }
    
    /// Rated or working pressure of cylinder
    public var ratedPressure: Double
    /// Capacity of cylinder
    public var volume: Double
    /// `DKTankType` of cylinder
    public var type: DKTankType
    
    /**
    Initializes `DKTankType` with the specified values.
     - parameter ratedPressure: Double representing the rated pressure of cylinder.
     - parameter volume: Double representing the capacity of cylinder.
     - parameter type: `DKTankType` representing the type of cylinder.
    - since: 1.0
    */
    public init(ratedPressure: Double, volume: Double, type: DKTankType) {
        self.ratedPressure = ratedPressure
        self.volume = volume
        self.type = type
    }
}
