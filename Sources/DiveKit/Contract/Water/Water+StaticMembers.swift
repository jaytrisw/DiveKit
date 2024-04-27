import Foundation

public extension Water {
    static var salt: Self {
        .init(
            weight: { .init($0 == .imperial ? 64 : 1.03, units: $0) },
            pressure: { .init(increase: .init($0 == .imperial ? 33 : 10, units: $0)) })
    }

    static var fresh: Self {
        .init(
            weight: { .init($0 == .imperial ? 62.4 : 1, units: $0) },
            pressure: { .init(increase: .init($0 == .imperial ? 34 : 10.3, units: $0)) })
    }
}
