//  DiveKit.swift
//  Copyright © 2020 Joshua Wood. All rights reserved.

/// DiveKit object holds values for water type and unit of measurenments.
public class DiveKit {
    // MARK: - Enumerations
    /// The type of water to use when performing calculations.
    public enum WaterType: String {
        /// Water which contains salt, typically found in the ocean.
        case saltWater = "Saltwater"
        /// Water which does not contain salt, typically found in lakes and rivers.
        case freshWater = "Freshwater"
        /// Returns string descibing enumeration case.
        public var description: String {
            return self.rawValue
        }
    }
    /// The unit of measurement to use when performing calculations, also which unit of measure calculations will be returned in.
    public enum MeasurementUnit: String {
        /// The unit of meansure used primarily by the United States.
        case imperial = "Imperial"
        /// The unit of measure used by literally the rest of the world.
        case metric = "Metric"
        /// Returns string descibing enumeration case.
        public var description: String {
            return self.rawValue
        }
        /// Units describing units for depth, weight, volume and pressure.
        public var units: Units {
            switch self {
            case .imperial:
                return Units(depthUnit: "foot", depthUnitShort: "ft", depthUnitPlural: "feet", depthUnitPluralShort: "ft", weightUnit: "pound", weightUnitShort: "lb", weightUnitPlural: "Pounds", weightUnitPluralShort: "lbs", volumeUnit: "cubic foot", volumeUnitShort: "ft³", volumeUnitPlural: "cubic feet", volumeUnitPluralShort: "ft³", pressureUnit: "pounds per square inch", pressureUnitShort: "psi")
            case .metric:
                return Units(depthUnit: "metre", depthUnitShort: "m", depthUnitPlural: "metres", depthUnitPluralShort: "m", weightUnit: "kilogram", weightUnitShort: "kg", weightUnitPlural: "kilograms", weightUnitPluralShort: "kg", volumeUnit: "litre", volumeUnitShort: "l", volumeUnitPlural: "litres", volumeUnitPluralShort: "l", pressureUnit: "bar", pressureUnitShort: "bar")
            }
        }
    }
    
    /// An object to hold values for contants.
    public struct Constants {
        /// The weight of a volume of water
        private(set) public var weightOfWater: Double
        /// Depth representing the increase in pressure by one atmosphere
        private(set) public var oneAtmosphere: Double
        /// The change in pressure per unit of depth
        private(set) public var pressureChange: Double
    }
    
    /// An object to hold string representations of units for depth, weight, volume and pressure.
    public struct Units {
        /// Singular unit for depth
        private(set) public var depthUnit: String
        /// Singular unit for depth
        private(set) public var depthUnitShort: String
        /// Plural unit for depth
        private(set) public var depthUnitPlural: String
        /// Plural unit for depth
        private(set) public var depthUnitPluralShort: String
        /// Singular unit for weight
        private(set) public var weightUnit: String
        /// Singular unit for weight
        private(set) public var weightUnitShort: String
        /// Plural unit for weight
        private(set) public var weightUnitPlural: String
        /// Plural unit for weight
        private(set) public var weightUnitPluralShort: String
        /// Singular unit for volume
        private(set) public var volumeUnit: String
        /// Singular unit for volume
        private(set) public var volumeUnitShort: String
        /// Plural unit for volume
        private(set) public var volumeUnitPlural: String
        /// Plural unit for volume
        private(set) public var volumeUnitPluralShort: String
        /// Singular unit for pressure
        private(set) public var pressureUnit: String
        /// Singular unit for pressure
        private(set) public var pressureUnitShort: String
    }
    
    // MARK: - Instance Properties
    /// Property storing the water type to be used by an instance of a DiveKit object.
    private(set) public var waterType: DiveKit.WaterType = .saltWater
    /// Property storing the unit measure to be used by an instance of a DiveKit object.
    private(set) public var measurementUnit: DiveKit.MeasurementUnit = .imperial
    /// Property storing constant values based on `DiveKit.WaterType` and `DiveKit.MeasurementUnit`
    public var constants: DiveKit.Constants {
        switch waterType {
        case .saltWater:
            switch measurementUnit {
            case .imperial:
                return Constants(weightOfWater: 64, oneAtmosphere: 33, pressureChange: 0.0303)
            case .metric:
                return Constants(weightOfWater: 1.03, oneAtmosphere: 10, pressureChange: 0.1)
            }
        case .freshWater:
            switch measurementUnit {
            case .imperial:
                return Constants(weightOfWater: 62.4, oneAtmosphere: 34, pressureChange: 0.0294)
            case .metric:
                return Constants(weightOfWater: 1, oneAtmosphere: 10.3, pressureChange: 0.097)
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
