import Foundation

/// The `PhysicsCalculating` protocol defines the requirements for performing physics-based calculations,
/// such as calculating pressure at a specific depth. Types conforming to this protocol must also conform to the
/// `ConfigurationProviding` protocol, ensuring they can provide necessary configuration details for the calculations.
public protocol PhysicsCalculating: ConfigurationProviding {

    /// Calculates the gauge pressure at a specified depth.
    ///
    /// Gauge pressure is the pressure relative to the ambient pressure. In many applications,
    /// it's crucial to understand how pressure changes with depth, especially in fluid dynamics
    /// and undersea or atmospheric studies.
    ///
    /// - Parameter depth: The depth at which to calculate the gauge pressure, typically measured in meters.
    /// - Returns: A `Calculation` object representing the gauge pressure at the given depth. The value
    ///   is of type `Double` and the unit is specified by `Units.Pressure`, indicating the
    ///   pressure unit used
    /// - Throws: Can throw an error if the calculation is not possible with the provided parameters or
    ///   if the configuration is invalid or insufficient for the calculation. Implementers should specify
    ///   the conditions under which errors are thrown.
    func gaugePressure(at depth: Double) throws -> Calculation<Double, Units.Pressure>
}
