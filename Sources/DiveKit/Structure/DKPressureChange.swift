//  DKPressureChange.swift

import Foundation

/**
 An object which contains the constant values of one atmosphere represented by depth in saltwater and freshwater.
 */
public struct DKAtmosphereContants {
    /// Water which contains salt, typically found in the ocean.
    internal(set) public var saltWater: Double = 0
    /// Water which does not contain salt, typically found in lakes and rivers.
    internal(set) public var freshWater: Double = 0
}
