import Testing
@testable import DiveKit

@Suite("Physics Calculator", .tags(.physicsCalculator))
struct PhysicsCalculatorMetricSaltwaterTestCase {

    @Test(.tags(.saltWater, .metric))
    func metricSaltwaterPressureChangeReturnsAtmospheresDelta() async throws {
        try await given {
            PhysicsCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.pressureChange(from: Depth(10), to: Depth(20))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(1))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .metric))
    func metricSaltwaterAirVolumeFromSurfaceReturnsVolumeUnit() async throws {
        try await given {
            PhysicsCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.airVolumeFromSurface(to: Depth(20), with: Volume(6))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(2))
            #expect(calculation.result.unit == .liters)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .metric))
    func metricSaltwaterAirVolumeToSurfaceReturnsVolumeUnit() async throws {
        try await given {
            PhysicsCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.airVolumeToSurface(from: Depth(20), with: Volume(6))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(18))
            #expect(calculation.result.unit == .liters)
            #expect(calculation.configuration == sut.configuration)
        }
    }
}
