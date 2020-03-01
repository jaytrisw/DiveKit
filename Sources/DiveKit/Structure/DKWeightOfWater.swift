//  DKWeightOfWater.swift

import Foundation

/**
An object which contains the constant values of the weight saltwater and freshwater, the `DKUnitsOfMeasure` and the `DKUnitsOfVolume` of water.
*/
public struct DKWeightOfWater {
    /// Water which contains salt, typically found in the ocean.
    internal(set) public var saltWater: Double = 0
    /// Water which does not contain salt, typically found in lakes and rivers.
    internal(set) public var freshWater: Double = 0
    /// Unit of measure
    internal(set) public var unit: DKUnitsOfMeasure = .notSet
    /// Unit of volume
    internal(set) public var volume: DKUnitsOfVolume = .notSet
}
