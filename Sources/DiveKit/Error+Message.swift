import Foundation

extension Error.Message {
    static func physicsCalculator(_ other: Self) -> Self {
        .init(key: "dive.kit.physics.calculator.\(other.key)")
    }

    static var negativeDepth: Self {
        .init(key: "negative.depth")
    }

    static var negativeVolume: Self {
        .init(key: "negative.volume")
    }
}
