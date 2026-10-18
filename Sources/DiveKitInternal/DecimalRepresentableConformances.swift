import Foundation
import DiveKitCore

/// Allows ``DiveKitCore/Depth`` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Depth: DecimalRepresentable {}
/// Allows ``DiveKitCore/Mass`` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Mass: DecimalRepresentable {}
/// Allows ``DiveKitCore/Minutes`` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Minutes: DecimalRepresentable {}
/// Allows ``DiveKitCore/PartialPressure`` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension PartialPressure: DecimalRepresentable {}
/// Allows ``DiveKitCore/Pressure`` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Pressure: DecimalRepresentable {}
/// Allows ``DiveKitCore/Rate`` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Rate: DecimalRepresentable {}
/// Allows ``DiveKitCore/Volume`` to participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Volume: DecimalRepresentable {}
