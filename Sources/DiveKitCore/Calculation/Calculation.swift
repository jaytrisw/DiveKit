import Foundation

/// A value produced by a calculation together with the configuration used.
///
/// `Calculation` keeps result values tied to the units and water model that
/// produced them, which is especially important for values that carry units.
///
/// ## Example
///
/// ```swift
/// let calculation = try calculator.gaugePressure(at: 30)
/// let pressure = calculation.result
/// let configuration = calculation.configuration
/// ```
///
/// - Since: 1.0.0
public struct Calculation<Result: ResultRepresentable>: Sendable {
    /// The calculated value.
    ///
    /// - Since: 1.0.0
    public let result: Result

    /// The configuration used to produce `result`.
    ///
    /// - Since: 1.0.0
    public let configuration: Configuration

    /// Creates a calculation result.
    ///
    /// - Parameters:
    ///   - result: The calculated value.
    ///   - configuration: The configuration used to produce `result`.
    /// - Since: 1.0.0
    package init(result: Result, configuration: Configuration) {
        self.result = result
        self.configuration = configuration
    }
}

/// Allows calculations to be compared when their result type is equatable.
///
/// - Since: 1.0.0
extension Calculation: Equatable where Result: Equatable {}
