import Foundation

package extension Error.Message {
    static func physicsCalculator(_ other: Self) -> Self {
        .init(key: "dive.kit.physics.calculator.\(other.key)")
    }

    static func gasCalculator(_ other: Self) -> Self {
        .init(key: "dive.kit.gas.calculator.\(other.key)")
    }

    static var negativeDepth: Self {
        .init(key: "negative.depth")
    }

    static var negativeVolume: Self {
        .init(key: "negative.volume")
    }

    static func negative(_ other: Self) -> Self {
        .init(key: "negative.\(other.key)")
    }

    static var time: Self {
        .init(key: "time")
    }

    static var consumed: Self {
        .init(key: "consumed")
    }

    static var depth: Self {
        .init(key: "depth")
    }

    static func blend(_ other: Self) -> Self {
        .init(key: "dive.kit.blend.\(other.key)")
    }

    static var totalPressure: Self {
        .init(key: "total.pressure")
    }

    static var pressureRange: Self {
        .init(key: "pressure.range")
    }
}
