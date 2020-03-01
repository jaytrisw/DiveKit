//
//  DKBuoyancy.swift
//

import Foundation
/**
 An object that represents the buoyancy of a physical object.
 */
public enum DKBuoyancy {
    /// Positively buoyant
    case positive(Double)
    /// Negatively buoyant
    case negative(Double)
    /// Neutrally buoyant
    case neutral
}
