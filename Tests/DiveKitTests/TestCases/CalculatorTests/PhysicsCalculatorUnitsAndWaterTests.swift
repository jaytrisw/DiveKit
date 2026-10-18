import Testing
@testable import DiveKit
import DiveKitTestSupport

/// Expected values are exact decimal results, rounded to `Double`, of the
/// formulas below with each configuration's depth per atmosphere `d`
/// (33 ft, 34 ft, 10 m, 10.3 m). 30 is in feet or meters.
@Suite("Physics calculator units and water", .tags(.physicsCalculator, .imperial, .metric, .saltWater, .freshWater))
struct PhysicsCalculatorUnitsAndWaterTests {
    /// 1 + 30 / d.
    @Test(arguments: zip(TestConfiguration.allCases, [1.9090909090909092, 1.8823529411764706, 4.0, 3.912621359223301]))
    func atmospheresAbsolute(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            PhysicsCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.atmospheresAbsolute(at: 30)
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    /// 30 / d.
    @Test(arguments: zip(TestConfiguration.allCases, [0.9090909090909091, 0.8823529411764706, 3.0, 2.912621359223301]))
    func gaugePressure(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            PhysicsCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.gaugePressure(at: 30)
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == .atmospheres)
        }
    }

    /// (30 − 10) / d.
    @Test(arguments: zip(TestConfiguration.allCases, [0.6060606060606061, 0.5882352941176471, 2.0, 1.941747572815534]))
    func pressureChange(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            PhysicsCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.pressureChange(from: 10, to: 30)
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == .atmospheres)
        }
    }

    /// 10 / (1 + 30 / d).
    @Test(arguments: zip(TestConfiguration.allCases, [5.238095238095238, 5.3125, 2.5, 2.555831265508685]))
    func airVolumeFromSurface(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            PhysicsCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.airVolumeFromSurface(to: 30, with: 10)
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == (configuration.units == .imperial ? .cubicFeet : .liters))
        }
    }

    /// 10 × (1 + 30 / d).
    @Test(arguments: zip(TestConfiguration.allCases, [19.09090909090909, 18.823529411764707, 40.0, 39.12621359223301]))
    func airVolumeToSurface(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            PhysicsCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.airVolumeToSurface(from: 30, with: 10)
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == (configuration.units == .imperial ? .cubicFeet : .liters))
        }
    }
}
