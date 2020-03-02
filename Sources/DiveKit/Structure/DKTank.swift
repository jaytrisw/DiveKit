//  DKTank.swift

import Foundation

/**
An object that represents a scuba diving cylinder.
- since: 0.9
*/
public struct DKTank {
    /**
    The type of scuba diving cylinder.
    - since: 0.9
    */
    public enum DKTankType {
        /// Standard aluminum cylinder is neutrally buoyant when at rated fill pressure.
        case aluminumStandard
        /// Compact aluminum cylinder is neutrally buoyant when empty.
        case aluminumCompact
        /// Steel cylinder
        case steel
    }
    
    public var ratedPressure: Double
    public var volume: Double
    public var type: DKTankType
    
    public init(ratedPressure: Double, volume: Double, type: DKTankType) {
        self.ratedPressure = ratedPressure
        self.volume = volume
        self.type = type
    }
}
