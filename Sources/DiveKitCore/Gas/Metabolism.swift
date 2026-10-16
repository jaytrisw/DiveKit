import Foundation

/// How the body handles a gas.
///
/// - Since: 1.0.0
public enum Metabolism: Sendable, Equatable, Hashable {
    /// The gas dissolves in tissue and is eliminated unchanged, such as nitrogen
    /// or helium. Inert gases load tissue compartments.
    ///
    /// - Since: 1.0.0
    case inert

    /// The gas is consumed or produced by the body, such as oxygen. Metabolic
    /// gases are not modeled by tissue compartments.
    ///
    /// - Since: 1.0.0
    case metabolic
}
