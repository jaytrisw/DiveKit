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
    
    public struct Constants {
        private(set) public var weightOfWater: Double
        private(set) public var oneAtmosphere: Double
        private(set) public var pressureChange: Double
        private(set) public var weightUnit: String
        private(set) public var depthUnit: String
    }
    // MARK: - Instance Properties
    /// Property storing the water type to be used by an instance of a DiveKit object.
    private(set) public var waterType: DiveKit.WaterType = .saltWater
    /// Property storing the unit measure to be used by an instance of a DiveKit object.
    private(set) public var measurementUnit: DiveKit.MeasurementUnit = .imperial
    
    public var constants: DiveKit.Constants {
        switch waterType {
        case .saltWater:
            switch measurementUnit {
            case .imperial:
                return Constants(weightOfWater: 64, oneAtmosphere: 33, pressureChange: 0.0303, weightUnit: "pound", depthUnit: "foot")
            case .metric:
                return Constants(weightOfWater: 1.03, oneAtmosphere: 10, pressureChange: 0.1, weightUnit: "kilogram", depthUnit: "meter")
            }
        case .freshWater:
            switch measurementUnit {
            case .imperial:
                return Constants(weightOfWater: 62.4, oneAtmosphere: 34, pressureChange: 0.0294, weightUnit: "pound", depthUnit: "foot")
            case .metric:
                return Constants(weightOfWater: 1, oneAtmosphere: 10.3, pressureChange: 0.097, weightUnit: "kilogram", depthUnit: "meter")
            }
        }
    }
    // MARK: - Initializers
    /**
     Initializes a DiveKit object using default values of salt water with imperial units.
     - since: 1.0
     */
    public init() {}
    /**
     Initializes a DiveKit object using provided parameters
     - parameter waterType: `DiveKit.WaterType`
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType, measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        self.waterType = waterType
        self.measurementUnit = measurementUnit
    }
    /**
     Initializes a DiveKit object using provided parameter for water type and default value of imperial units
     - parameter waterType: `DiveKit.WaterType`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType) {
        self.init()
        self.waterType = waterType
    }
    /**
     Initializes a DiveKit object using provided parameter for unit of measure and default value of salt water.
     - parameter measurementUnit: `DiveKit.MeasurementUnit`
     - since: 1.0
     */
    public convenience init(measurementUnit: DiveKit.MeasurementUnit) {
        self.init()
        self.measurementUnit = measurementUnit
    }
}
