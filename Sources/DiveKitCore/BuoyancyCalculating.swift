import Foundation

/// A calculator that performs buoyancy calculations.
///
/// Conforming types report invalid domain inputs, such as negative weights or
/// volumes, by throwing ``Error``.
///
/// - Since: 1.0.0
public protocol BuoyancyCalculating {
    /// Calculates buoyancy for an object.
    ///
    /// - Parameter object: The object to evaluate.
    /// - Returns: A calculation containing the object's buoyancy.
    /// - Throws: ``Error/negative(_:_:)`` if the object's weight or volume is negative.
    /// - Since: 1.0.0
    func buoyancy(
        of object: Object) throws(Error) -> Calculation<Buoyancy>

    /// Calculates buoyancy from weight and displaced volume.
    ///
    /// - Parameters:
    ///   - weight: The object's weight.
    ///   - volume: The object's displaced volume.
    /// - Returns: A calculation containing the resulting buoyancy.
    /// - Throws: ``Error/negative(_:_:)`` if `weight` or `volume` is negative.
    /// - Since: 1.0.0
    func buoyancyOfObject(
        weighing weight: Mass,
        andDisplacing volume: Volume) throws(Error) -> Calculation<Buoyancy>

    /// Calculates object volume from weight and buoyancy.
    ///
    /// - Parameters:
    ///   - weight: The object's weight.
    ///   - buoyancy: The object's buoyancy.
    /// - Returns: A calculation containing the resulting volume.
    /// - Throws: ``Error/negative(_:_:)`` if `weight` is negative.
    /// - Since: 1.0.0
    func volumeOfObject(
        weighing weight: Mass,
        with buoyancy: Buoyancy) throws(Error) -> Calculation<DecimalResult<Volume>>
}
