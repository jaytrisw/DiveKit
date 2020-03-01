//  DKGas.swift

import Foundation

/// An object that represents a breathing gas used during scuba diving.
public enum DKGas {
    /// A property that represents compressed atmospheric air.
    case air
    /// A property that represents a gas containing a percentage of oxygen greater than 20.9%
    case enrichedAir(percentage: Double)
    
    // MARK: - Computed Properties
    /**
     A property that represents the partial pressures, as a `DKPartialPressure` object, of the constituent gases in a specific diving gas.
     - since: 0.9
     */
    public var partialPressure: DKPartialPressure {
        switch self {
        case .air: return DKPartialPressure(oxygen: 0.209, nitrogen: 0.79, trace: 0.001)
        case .enrichedAir(let blend): return DKPartialPressure(oxygen: blend / 100, nitrogen: (100 - blend) / 100, trace: 0)
        }
    }
    /**
    A property that represents the percentage of oxygen in a specific diving gas.
    - since: 0.9
    */
    public var percentOxygen: Double {
        switch self {
        case .air:
            return 20.9
        case .enrichedAir(let blend):
            return blend
        }
    }
}
