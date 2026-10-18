import Foundation

/// A calculator that tracks inert gas in a diver's tissues and plans the ascent.
///
/// A conforming type owns its model's state as ``Tissues``: start from
/// ``surfaceTissues()``, load the dive with ``loaded(_:through:)``, and pass
/// the result to ``ceiling(of:)``, ``noDecompressionLimit(of:at:breathing:)``
/// or ``schedule(of:from:breathing:switchingTo:)``. Conforming types report
/// invalid domain inputs, such as negative depths, by throwing ``Error``.
///
/// - Warning: DiveKit's decompression calculations have not been validated for
///   planning real dives.
///
/// - Since: 1.0.0
public protocol DecompressionCalculating: ConfigurationProviding {
    /// The inert-gas loading of a diver's tissues, in the calculator's model.
    ///
    /// - Since: 1.0.0
    associatedtype Tissues: Sendable, Equatable

    /// Returns tissues saturated at the surface on air.
    ///
    /// - Returns: The tissues before a dive.
    /// - Throws: ``Error`` if the calculator's settings are invalid.
    /// - Since: 1.0.0
    func surfaceTissues() throws(Error) -> Tissues

    /// Returns tissues after a dive profile.
    ///
    /// - Parameters:
    ///   - tissues: The tissues at the start of the profile.
    ///   - profile: The segments, in order, with depths in the configured units.
    /// - Returns: The tissues at the end of the profile.
    /// - Throws: ``Error`` if a segment or the calculator's settings are invalid.
    /// - Since: 1.0.0
    func loaded(_ tissues: Tissues, through profile: [DiveSegment]) throws(Error) -> Tissues

    /// Calculates the shallowest depth the tissues tolerate.
    ///
    /// - Parameter tissues: The tissues.
    /// - Returns: A calculation containing the ceiling depth, or `0` if the
    ///   tissues tolerate the surface.
    /// - Throws: ``Error`` if the calculator's settings are invalid.
    /// - Since: 1.0.0
    func ceiling(of tissues: Tissues) throws(Error) -> Calculation<DecimalResult<Depth>>

    /// Calculates how long the tissues can stay at a depth and still ascend directly to the surface.
    ///
    /// - Parameters:
    ///   - tissues: The tissues on arrival at `depth`.
    ///   - depth: The depth, in the configured units.
    ///   - blend: The breathing gas.
    /// - Returns: A calculation containing the no-decompression limit.
    /// - Throws: ``Error`` if `depth` or the calculator's settings are invalid.
    /// - Since: 1.0.0
    func noDecompressionLimit(
        of tissues: Tissues,
        at depth: Depth,
        breathing blend: Blend<Blended>) throws(Error) -> Calculation<NoDecompressionLimit>

    /// Calculates an ascent from depth to the surface, with decompression stops and gas switches.
    ///
    /// - Parameters:
    ///   - tissues: The tissues at the start of the ascent.
    ///   - depth: The depth at the start of the ascent, in the configured units.
    ///   - blend: The gas breathed at the start of the ascent.
    ///   - gases: Gases to switch to during the ascent.
    /// - Returns: A calculation containing the schedule.
    /// - Throws: ``Error`` if `depth`, a gas, or the calculator's settings are
    ///   invalid, or if no schedule can be found.
    /// - Since: 1.0.0
    func schedule(
        of tissues: Tissues,
        from depth: Depth,
        breathing blend: Blend<Blended>,
        switchingTo gases: [Blend<Blended>]) throws(Error) -> Calculation<DecompressionSchedule>
}
