import Foundation

/// A type that owns a `Configuration`.
///
/// Calculators conform to `ConfigurationProviding` so convenience APIs can use
/// the receiver's unit and water settings.
///
/// - Since: 1.0.0
public protocol ConfigurationProviding {
    /// The configuration used by the conforming type.
    ///
    /// - Since: 1.0.0
    var configuration: Configuration { get }

    /// Creates an instance with a configuration.
    ///
    /// - Parameter configuration: The configuration used by the conforming type.
    /// - Since: 1.0.0
    init(configuration: Configuration)
}
