//  DiveKit.swift
//  Copyright © 2020 Joshua Wood. All rights reserved.

/**
 DiveKit object holds values for water type and unit of measurenments.
 */
public class DiveKit {
    // MARK: - Enumerations
    /// The type of water to use when performing calculations.
    public enum WaterType {
        /// Water which contains salt, typically found in the ocean.
        case saltWater
        /// Water which does not contain salt, typically found in lakes and rivers.
        case freshWater
    }
    /// The unit of measurement to use when performing calculations, also which unit of measure calculations will be returned in.
    public enum MeasurementUnit {
        /// The unit of meansure used primarily by the United States.
        case imperial
        /// The unit of measure used by literally the rest of the world.
        case metric
    }
    // MARK: - Instance Properties
    /// Property storing the water type to be used by an instance of a DiveKit object.
    private(set) public var waterType: DiveKit.WaterType = .saltWater
    /// Property storing the unit measure to be used by an instance of a DiveKit object.
    private(set) public var measurementUnit: DiveKit.MeasurementUnit = .imperial
    // MARK: - Initializers
    /**
     Initializes a DiveKit object using default values of salt water with imperial units.
     - since: 0.9
     */
    public init() {}
    /**
     Initializes a DiveKit object using provided parameters
     - parameter waterType: `DiveKit.WaterType`
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType, measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        self.waterType = waterType
        self.measurementUnit = measurementUnit
    }
    /**
     Initializes a DiveKit object using provided parameter for water type and default value of imperial units
     - parameter waterType: `DiveKit.WaterType`
     - since: 0.9
     */
    public convenience init(waterType: DiveKit.WaterType) {
        self.init()
        self.waterType = waterType
    }
    /**
     Initializes a DiveKit object using provided parameter for unit of measure and default value of salt water.
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 0.9
     */
    public convenience init(measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        self.measurementUnit = measurementUnit
    }
}
