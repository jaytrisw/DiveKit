import Foundation

/// A scuba tank with a validated gas blend and physical size.
///
/// `Tank` stores the blend and size information needed for gas consumption and
/// respiratory minute volume calculations.
///
/// - Since: 1.0.0
public struct Tank: Sendable {
    /// The gas blend contained in the tank.
    ///
    /// - Since: 1.0.0
    public let blend: Blend<Blended>

    /// The tank's volume and rated pressure.
    ///
    /// - Since: 1.0.0
    public let size: Size

    /// Creates a tank.
    ///
    /// - Parameters:
    ///   - blend: The gas blend contained in the tank.
    ///   - size: The tank's volume and rated pressure.
    /// - Since: 1.0.0
    public init(blend: Blend<Blended>, size: Size) {
        self.blend = blend
        self.size = size
    }
}

/// Allows tanks to be compared by blend and size.
///
/// - Since: 1.0.0
extension Tank: Equatable {}
