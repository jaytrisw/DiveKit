import Foundation
import DiveKitCore

/// Makes ``DiveKitCore/Depth`` participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Depth: DecimalRepresentable {}
/// Makes ``DiveKitCore/Mass`` participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Mass: DecimalRepresentable {}
/// Makes ``DiveKitCore/Minutes`` participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Minutes: DecimalRepresentable {}
/// Makes ``DiveKitCore/PartialPressure`` participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension PartialPressure: DecimalRepresentable {}
/// Makes ``DiveKitCore/Pressure`` participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Pressure: DecimalRepresentable {}
/// Makes ``DiveKitCore/Rate`` participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Rate: DecimalRepresentable {}
/// Makes ``DiveKitCore/Volume`` participate in internal decimal calculation pipelines.
///
/// - Since: 1.0.0
extension Volume: DecimalRepresentable {}
