import Testing
@testable import DiveKit
import DiveKitTestSupport

/// Expected values are exact decimal results, rounded to `Double`, of the
/// formulas below with each configuration's depth per atmosphere `d`
/// (33 ft, 34 ft, 10 m, 10.3 m). Depths are in feet or meters.
@Suite("Gas calculator units and water", .tags(.gasCalculator, .imperial, .metric, .saltWater, .freshWater))
struct GasCalculatorUnitsAndWaterTests {
    /// EAN32 at 1.4: (1.4 / 0.32 − 1) × d.
    @Test(arguments: zip(TestConfiguration.allCases, [111.375, 114.75, 33.75, 34.7625]))
    func maximumOperatingDepth(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            GasCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.maximumOperatingDepth(for: 1.4, in: .enrichedAir(0.32))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == (configuration.units == .imperial ? .feet : .meters))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    /// EAN32 at 30: (30 + d) × 0.68 / 0.79 − d.
    @Test(arguments: zip(TestConfiguration.allCases, [21.227848101265824, 21.088607594936708, 24.430379746835442, 24.38860759493671]))
    func equivalentAirDepth(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            GasCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.equivalentAirDepth(for: 30, with: .enrichedAir(0.32))
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == (configuration.units == .imperial ? .feet : .meters))
        }
    }

    /// 32% oxygen at 30: 0.32 × (1 + 30 / d).
    @Test(arguments: zip(TestConfiguration.allCases, [0.610909090909091, 0.6023529411764705, 1.28, 1.2520388349514564]))
    func partialPressure(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            GasCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.partialPressure(
                of: Oxygen(),
                in: .enrichedAir(0.32),
                at: 30,
                using: PhysicsCalculator(configuration.units, water: configuration.water))
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
        }
    }

    /// 50 consumed over 10 minutes at 30: (50 / 10) / (1 + 30 / d).
    @Test(arguments: zip(TestConfiguration.allCases, [2.619047619047619, 2.65625, 1.25, 1.2779156327543424]))
    func surfaceAirConsumption(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            GasCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.surfaceAirConsumption(
                at: 30,
                for: 10,
                start: 150,
                end: 100,
                using: PhysicsCalculator(configuration.units, water: configuration.water))
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == .perMinute(configuration.units == .imperial ? .psi : .bar))
        }
    }
}
