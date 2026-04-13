import Foundation
import DiveKitCore

/// Allows `Depth` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Depth: DecimalRepresentable {}
/// Allows `Mass` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Mass: DecimalRepresentable {}
/// Allows `Minutes` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Minutes: DecimalRepresentable {}
/// Allows `PartialPressure` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension PartialPressure: DecimalRepresentable {}
/// Allows `Pressure` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Pressure: DecimalRepresentable {}
/// Allows `Rate` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Rate: DecimalRepresentable {}
/// Allows `Volume` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Volume: DecimalRepresentable {}
