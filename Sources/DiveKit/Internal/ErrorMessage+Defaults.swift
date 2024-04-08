import Foundation

package extension Error.Message {
    static func physicsCalculator(_ other: Self) -> Self {
        .init(key: "dive.kit.physics.calculator.\(other.key)")
    }

    static func gasCalculator(_ other: Self) -> Self {
        .init(key: "dive.kit.gas.calculator.\(other.key)")
    }

    static func buoyancyCalculator(_ other: Self) -> Self {
        .init(key: "dive.kit.buoyancy.calculator.\(other.key)")
    }

    static var invalidObject: Self {
        .init(key: "invalid.object")
    }

    static var invalidTank: Self {
        .init(key: "invalid.tank")
    }

    static func negative(_ other: Self) -> Self {
        .init(key: "negative.\(other.key)")
    }

    static var time: Self {
        .init(key: "time")
    }

    static var startPressure: Self {
        .init(key: "start.pressure")
    }

    static var endPressure: Self {
        .init(key: "end.pressure")
    }

    static var consumed: Self {
        .init(key: "consumed")
    }

    static var fractionOxygen: Self {
        .init(key: "fraction.oxygen")
    }

    static var depth: Self {
        .init(key: "depth")
    }

    static var volume: Self {
        .init(key: "volume")
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
