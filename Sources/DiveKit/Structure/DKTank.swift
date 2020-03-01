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
    
    var ratedPressure: Double
    var volume: Double
    var type: DKTankType
}
