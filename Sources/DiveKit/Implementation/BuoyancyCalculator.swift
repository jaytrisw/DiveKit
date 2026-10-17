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
    /// Calculates the buoyancy of an `Object`.
    ///
    /// - Parameter object: The object whose buoyancy should be calculated.
    /// - Returns: A calculation containing the resulting `Buoyancy`.
    /// - Throws: `Error.negative` if the object's weight or volume is
    ///   negative, or `Error.range` if the object's weight or volume, the water
    ///   model's weight, or the displaced water's weight is not finite, or if
    ///   the water model's weight is not greater than zero.
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

    /// Calculates the buoyancy of an object from its `Mass` and displaced `Volume`.
    ///
    /// - Parameters:
    ///   - weight: The weight of the object.
    ///   - volume: The volume of water displaced by the object.
    /// - Returns: A calculation containing the resulting `Buoyancy`.
    /// - Throws: `Error.negative` if `weight` or `volume` is negative, or
    ///   `Error.range` if `weight`, `volume`, the water model's weight, or the
    ///   displaced water's weight is not finite, or if the water model's weight
    ///   is not greater than zero.
    ///
    /// ```swift
    /// let result = try calculator.buoyancyOfObject(
    ///     weighing: 10,
    ///     andDisplacing: 8)
    /// ```
    ///
    /// - Since: 1.0.0
    public func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws(DiveKit.Error) -> Calculation<Buoyancy> {
            let callSite: CallSite = .from(self)
            return try buoyancy(
                of: .init(weight: weight, volume: volume),
                with: configuration,
                callSite)
        }

    /// Calculates the volume of an object given its `Mass` and `Buoyancy`.
    ///
    /// - Parameters:
    ///   - weight: The weight of the object.
    ///   - buoyancy: The buoyancy of the object.
    /// - Returns: A calculation containing the resulting volume.
    /// - Throws: `Error.negative` if `weight` or the resulting volume is
    ///   negative, or `Error.range` if `weight`, `buoyancy`, the water model's
    ///   weight, or the result is not finite, or if a non-neutral `buoyancy`
    ///   magnitude or the water model's weight is not greater than zero.
    ///
    /// ```swift
    /// let result = try calculator.volumeOfObject(
    ///     weighing: 10,
    ///     with: buoyancy)
    /// ```
    ///
    /// - Since: 1.0.0
    public func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws(DiveKit.Error) -> Calculation<DecimalResult<Volume>> {
            let callSite: CallSite = .from(self)
            let waterWeight = try configuration.waterWeight(callSite)
            switch buoyancy {
                case let .positive(magnitude), let .negative(magnitude):
                    try magnitude
                        .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
                        .validate(using: .greater(than: 0)) { .range(.lowerBound($0, 0), callSite) }
                case .neutral:
                    break
            }
            return try weight
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { $0.value + buoyancy.buoyantForce }
                .validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
                .map { Volume($0 / waterWeight) }
                .validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
                .validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { .decimal($0.value, unit: \.volume, from: configuration) }
        }
}
