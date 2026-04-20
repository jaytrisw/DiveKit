import Testing
@testable import DiveKit

@Suite("Gas Calculator", .tags(.gasCalculator))
struct GasCalculatorMetricSaltwaterTestCase {

    @Test(.tags(.saltWater, .metric))
    func metricSaltwaterSurfaceAirConsumption() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.surfaceAirConsumption(
                at: 15,
                for: 10,
                consuming: 40,
                using: PhysicsCalculator(.metric, water: .salt))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(1.6))
            #expect(calculation.result.unit == .perMinute(.bar))
            #expect(calculation.configuration == sut.configuration)
        }
    }
}
