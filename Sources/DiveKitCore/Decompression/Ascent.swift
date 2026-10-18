import Foundation

/// The rate and stop depths of a diver's ascent.
///
/// Decompression stops fall at ``lastStop`` and at every ``stopInterval``
/// below it. All values are in the configured units, so an ascent for metric depths is not
/// valid for imperial ones. Public construction that validates each value
/// lives in the top-level `DiveKit` module.
///
/// - Warning: DiveKit's decompression calculations have not been validated for
///   planning real dives.
///
/// - Since: 1.0.0
public struct Ascent: Sendable, Hashable {
    /// The ascent rate, in the configured depth units per minute.
    ///
    /// - Since: 1.0.0
    public let rate: Rate<Depth>

    /// The depth between decompression stops, in the configured units.
    ///
    /// - Since: 1.0.0
    public let stopInterval: Depth

    /// The shallowest decompression stop, in the configured units.
    ///
    /// - Since: 1.0.0
    public let lastStop: Depth

    /// Creates an ascent without validation.
    ///
    /// - Parameters:
    ///   - rate: The ascent rate, in the configured depth units per minute.
    ///   - stopInterval: The depth between decompression stops.
    ///   - lastStop: The shallowest decompression stop.
    /// - Warning: This package initializer does not validate that each value is
    ///   finite and greater than `0`.
    /// - Since: 1.0.0
    package init(unchecked rate: Rate<Depth>, stopInterval: Depth, lastStop: Depth) {
        self.rate = rate
        self.stopInterval = stopInterval
        self.lastStop = lastStop
    }
}
