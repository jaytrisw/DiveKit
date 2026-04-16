import Foundation
import DiveKitCore
import DiveKitInternal

/// A calculator for determining buoyancy-related properties of objects.
///
/// `BuoyancyCalculator` provides methods for calculating buoyancy, deriving
/// buoyancy from object properties, and solving for related values such as volume.
/// All calculations are performed using the provided configuration.
///
/// - Since: 1.0.0
public final class BuoyancyCalculator: ConfigurationProviding {

    /// The configuration used for all buoyancy calculations.
    ///
    /// - Since: 1.0.0
    public let configuration: Configuration

    /// Creates a new buoyancy calculator.
    ///
    /// - Parameter configuration: The configuration used for calculations.
    ///
    /// ```swift
    /// let calculator = BuoyancyCalculator(configuration: configuration)
    /// ```
    ///
    /// - Since: 1.0.0
    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension BuoyancyCalculator: BuoyancyCalculating {
    /// Calculates the buoyancy of an object.
    ///
    /// - Parameter object: The object whose buoyancy should be calculated.
    /// - Returns: A calculation containing the resulting `Buoyancy`.
    /// - Throws: `Error.negative` if the object's weight or volume is negative.
    ///
    /// ## Formula
    ///
    /// `buoyancy = displaced water weight - object weight`
    ///
    /// ```swift
    /// let result = try calculator.buoyancy(of: object)
    /// ```
    ///
    /// - Since: 1.0.0
    public func buoyancy(
        of object: Object) throws(DiveKit.Error) -> Calculation<Buoyancy> {
            try buoyancy(of: object, with: configuration, .from(self))
        }

    /// Calculates the buoyancy of an object from its weight and displaced volume.
    ///
    /// - Parameters:
    ///   - weight: The weight of the object.
    ///   - volume: The volume of water displaced by the object.
    /// - Returns: A calculation containing the resulting `Buoyancy`.
    /// - Throws: `Error.negative` if `weight` or `volume` is negative.
    ///
    /// ## Formula
    ///
    /// `buoyancy = displaced water weight - object weight`
    ///
    /// ```swift
    /// let result = try calculator.buoyancyOfObject(
    ///     weighing: 10,
    ///     andDisplacing: 8
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    public func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws(DiveKit.Error) -> Calculation<Buoyancy> {
            try weight
                .validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { (_: Mass) throws(DiveKit.Error) in
                    try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                }
                .map { (volume: Volume) throws(DiveKit.Error) in
                    try buoyancy(of: .init(weight: weight, volume: volume))
                }
        }

    /// Calculates the volume of an object given its weight and buoyancy.
    ///
    /// - Parameters:
    ///   - weight: The weight of the object.
    ///   - buoyancy: The buoyancy of the object.
    /// - Returns: A calculation containing the resulting volume.
    /// - Throws: `Error.negative` if `weight` is negative.
    ///
    /// ## Formula
    ///
    /// `volume = (weight + buoyant force) ÷ water density`
    ///
    /// ```swift
    /// let result = try calculator.volumeOfObject(
    ///     weighing: 10,
    ///     with: buoyancy
    /// )
    /// ```
    ///
    /// - Since: 1.0.0
    public func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws(DiveKit.Error) -> Calculation<DecimalResult<Volume>> {
            try weight.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { $0.value + buoyancy.buoyantForce }
                .map { $0 / configuration.water.weight(configuration.units).value }
                .map { .decimal($0, unit: \.volume, from: configuration) }
        }
}
