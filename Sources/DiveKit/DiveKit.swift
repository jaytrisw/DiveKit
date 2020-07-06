//  DiveKit.swift
//  Copyright © 2020 Joshua Wood. All rights reserved.

import Foundation

/// DiveKit object holds values for water type and unit of measurements.
public class DiveKit {
    // MARK: - Enumerations
    /// The type of water to use when performing calculations.
    public enum WaterType: String {
        /// Water which contains salt, typically found in the ocean.
        case saltWater = "Saltwater"
        /// Water which does not contain salt, typically found in lakes and rivers.
        case freshWater = "Freshwater"
        /// Returns string describing enumeration case.
        public var description: String {
            return self.rawValue
        }
    }
    /// The unit of measurement to use when performing calculations, also which unit of measure calculations will be returned in.
    public enum MeasurementUnit: String {
        /// The unit of measure used primarily by the United States.
        case imperial = "Imperial"
        /// The unit of measure used by literally the rest of the world.
        case metric = "Metric"
        /// Returns string describing enumeration case.
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
    
    /// An object to hold values for constants.
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
     Initializes a `DiveKit` object using default values of `DiveKit.WaterType.saltWater` and `DiveKit.MeasurementUnit.imperial`.
     - since: 1.0
     */
    public init() {}
    /**
     Initializes a `DiveKit` object using provided parameters
     - parameter waterType: `DiveKit.WaterType` default value `DiveKit.WaterType.saltWater`
     - parameter measurementUnit: `DiveKit.MeasurementUnit` default value `DiveKit.MeasurementUnit.imperial`
     - since: 1.0
     */
    public convenience init(waterType: DiveKit.WaterType = .saltWater, measurementUnit: DiveKit.MeasurementUnit = .imperial) {
        self.init()
        self.waterType = waterType
        self.measurementUnit = measurementUnit
    }
}

extension DiveKit {
    /// `DiveKit.Error` is the error type returned by DikeKit. It encompasses a few different types of errors, each with their own associated reasons.
    public enum Error: LocalizedError {
        /// `DiveKit.Error` representing the need for a positive parameter to be passed, associated values for `ErrorParameter` representing the parameter passed and `Double` representing the value passed.
        case positiveValueRequired(parameter: ErrorParameter, value: Double)
        /// `DiveKit.Error` representing the need for a parameter for a percentage passed that does not fall in range of 0% - 100%, associated values for `ErrorParameter` representing the parameter passed and `Double` representing the value passed.
        case percentage(title: ErrorParameter, value: Double)
        /// `DiveKit.Error` representing the the sum of the passed parameters to equal 100%, associated value of `Double` representing the sum of the values passed.
        case totalPercent(value: Double)
        /// `DiveKit.Error` representing the need for a parameter for a decimal passed that does not fall in range of 0.0 - 1.0, associated value of `Double` representing the decimal value passed.
        case decimal(value: Double)
        
        /// Returns an optional string that describes the title of the error.
        public var title: String? {
            switch self {
            case .positiveValueRequired(let parameter, _): return "\(parameter.rawValue) Error"
            case .percentage(let parameter, _): return "\(parameter.rawValue) Error"
            case .totalPercent: return "Percentage Error"
            case .decimal: return "Decimal Error"
            }
        }
        
        /// Returns an optional string that describes the error.
        public var errorDescription: String? {
            switch self {
            case .positiveValueRequired(let parameter, let value): return "\(parameter.rawValue) requires a positive value, \(value) was provided."
            case .percentage(let parameter, let value): return "\(parameter.rawValue) requires a value between 0 and 100, \(value) was provided."
            case .totalPercent(let value): return "Sum of the provided gas percentages does not equal 100%, \(value) was provided."
            case .decimal(let value): return "The provided decimal value should be within range of 0 and 1, \(value) was provided."
            }
        }
        
        /// Returns an optional string that describes reason for the error.
        public var failureReason: String? {
            switch self {
            case .positiveValueRequired(let parameter, let value): return "\(parameter.rawValue) requires a positive value, \(value) was provided."
            case .percentage(let parameter, let value): return "\(parameter.rawValue) requires a value between 0 and 100, \(value) was provided."
            case .totalPercent(let value): return "Sum of the provided gas percentages does not equal 100%, \(value) was provided."
            case .decimal(let value): return "The provided decimal value should be within range of 0 and 1, \(value) was provided."
            }
        }
        
        /// Returns an optional string that possible ways to recover from the error.
        public var recoverySuggestion: String? {
            switch self {
            case .positiveValueRequired(let parameter, let value): return "Provide a positive value for the \(parameter.rawValue.lowercased()) parameter, rather than \(value)"
            case .percentage(let parameter, let value): return "Provide a value between 0 and 100 for the \(parameter.rawValue.lowercased()) parameter, rather than \(value)"
            case .totalPercent(let value): return "Insure you are providing percentages of gassed that totals to 100%, \(value) was provided."
            case .decimal(let value): return "The provided decimal value should be within range of 0 and 1, \(value) was provided."
            }
        }
        
        /// Returns a Double representing the value passed, which triggered the error.
        public var value: Double {
            switch self {
                case .positiveValueRequired(_, let value): return value
                case .percentage(_, let value): return value
                case .totalPercent(let value): return value
                case .decimal(let value): return value
            }
        }
        /// `ErrorParameter` allows for a simple method for passing the error inducing parameter a `DiveKit.Error`.
        public enum ErrorParameter: String {
            /// Depth
            case depth = "Depth"
            /// Fraction of oxygen
            case fractionOxygen = "Fraction Oxygen"
            /// Time
            case time = "Time"
            /// Gas consumed
            case gasConsumed = "Gas Consumed"
            /// Volume
            case volume = "Volume"
            /// Tank pressure
            case tankPressure = "Tank Pressure"
            /// Decimal places
            case decimalPlaces = "Decimal Places"
            /// percentage of oxygen
            case percentOxygen = "Percent Oxygen"
            /// percentage of nitrogen
            case percentNitrogen = "Percent Nitrogen"
            /// percentage of trace gasses
            case percentTraceGas = "Percent Trace Gas"
            /// percentage of contaminant gas(es)
            case percentContaminantGas = "Percent Contaminant Gas"
        }
    }
}
