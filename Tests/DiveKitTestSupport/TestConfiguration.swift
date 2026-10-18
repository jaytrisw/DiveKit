import DiveKit
import Testing

/// The four unit and water combinations, for tests parameterized over them.
///
/// Expected values in those tests use DiveKit's documented constants: 33 ft
/// (salt) and 34 ft (fresh) per atmosphere with 64 and 62.4 lb/ft³, and 10 m
/// (salt) and 10.3 m (fresh) per atmosphere with 1.025 and 1.0 kg/L.
package enum TestConfiguration: String, CaseIterable, Sendable, CustomTestStringConvertible {
    case imperialSalt
    case imperialFresh
    case metricSalt
    case metricFresh

    package var units: Units {
        switch self {
            case .imperialSalt, .imperialFresh: .imperial
            case .metricSalt, .metricFresh: .metric
        }
    }

    package var water: Water {
        switch self {
            case .imperialSalt, .metricSalt: .salt
            case .imperialFresh, .metricFresh: .fresh
        }
    }

    package var testDescription: String {
        rawValue
    }
}
