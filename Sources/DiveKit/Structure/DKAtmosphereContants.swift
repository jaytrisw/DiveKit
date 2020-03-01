//  DKAtmosphereContants.swift

import Foundation

/**
An object which contains the constant change in pressue per foot or metre in saltwater and freshwater.
*/
public struct DKPressureChange {
    /// Water which contains salt, typically found in the ocean.
    internal(set) public var saltWater: Double = 0
    /// Water which does not contain salt, typically found in lakes and rivers.
    internal(set) public var freshWater: Double = 0
}
