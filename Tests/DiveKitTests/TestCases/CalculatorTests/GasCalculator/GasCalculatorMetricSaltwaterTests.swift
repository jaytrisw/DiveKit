import Testing
@testable import DiveKit

@Suite("Gas Calculator", .tags(.gasCalculator, .saltWater, .metric))
struct GasCalculatorMetricSaltwaterTests {

    @Test
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

    @Test
    func respiratoryMinuteVolumeWithLiterTank() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.respiratoryMinuteVolume(
                at: 0,
                for: 1,
                consuming: 1,
                with: Tank(
                    blend: .air,
                    size: .init(volume: 12, ratedPressure: 200, unit: .liters)),
                using: PhysicsCalculator(.metric, water: .salt))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(12))
            #expect(calculation.result.unit == .perMinute(.liters))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test
    func respiratoryMinuteVolumeWithCubicFootTank() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.respiratoryMinuteVolume(
                at: 0,
                for: 1,
                consuming: 1,
                with: Tank.cubicFeet(80, ratedPressure: 3000, with: .air),
                using: PhysicsCalculator(.metric, water: .salt))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(10.952008, with: .loose))
            #expect(calculation.result.unit == .perMinute(.liters))
            #expect(calculation.configuration == sut.configuration)
        }
    }
}
