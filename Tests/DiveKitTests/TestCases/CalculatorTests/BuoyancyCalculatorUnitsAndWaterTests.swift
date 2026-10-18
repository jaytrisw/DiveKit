import Testing
@testable import DiveKit
import DiveKitTestSupport

/// Expected values are exact decimal results, rounded to `Double`, using each
/// configuration's water density ρ (64 and 62.4 lb/ft³, 1.025 and 1.0 kg/L).
@Suite("Buoyancy calculator units and water", .tags(.buoyancyCalculator, .imperial, .metric, .saltWater, .freshWater))
struct BuoyancyCalculatorUnitsAndWaterTests {
    /// 50 weight displacing 50 volume: 50 × ρ − 50. Fresh metric water is exactly neutral.
    @Test(arguments: zip(TestConfiguration.allCases, [3150.0, 3070.0, 1.25, 0.0]))
    func buoyancyOfObject(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            BuoyancyCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.buoyancyOfObject(weighing: 50, andDisplacing: 50)
        } then: { sut, calculation in
            #expect(calculation.result.buoyantForce.isApproximately(expected))
            #expect((calculation.result == .neutral) == (expected == 0))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    /// A neutral object weighing 100: 100 / ρ.
    @Test(arguments: zip(TestConfiguration.allCases, [1.5625, 1.6025641025641026, 97.5609756097561, 100.0]))
    func volumeOfNeutralObject(configuration: TestConfiguration, expected: Double) async throws {
        try await given {
            BuoyancyCalculator(configuration.units, water: configuration.water)
        } when: { sut in
            try sut.volumeOfObject(weighing: 100, with: .neutral)
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(expected))
            #expect(calculation.result.unit == (configuration.units == .imperial ? .cubicFeet : .liters))
        }
    }
}
