import Foundation

/// A physical object used in buoyancy calculations.
///
/// `Object` combines weight and displaced volume so buoyancy calculations can
/// compare the object's weight with the weight of displaced water.
///
/// - Since: 1.0.0
public struct Object: Sendable {
    /// The object's weight.
    ///
    /// - Since: 1.0.0
    public let weight: Mass

    /// The object's displaced volume.
    ///
    /// - Since: 1.0.0
    public let volume: Volume

    /// Creates an object for buoyancy calculations.
    ///
    /// - Parameters:
    ///   - weight: The object's weight.
    ///   - volume: The object's displaced volume.
    /// - Since: 1.0.0
    public init(weight: Mass, volume: Volume) {
        self.weight = weight
        self.volume = volume
    }
}

/// Allows objects to be compared by weight and volume.
///
/// - Since: 1.0.0
extension Object: Equatable {}
