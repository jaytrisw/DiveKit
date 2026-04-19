import Testing
@testable import DiveKit

final class PhysicsCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<PhysicsCalculator> {

    @Test
    func testPressureChangeReturnsAtmospheresDelta() throws {
        // Given
        let fromDepth: Depth = 10
        let toDepth: Depth = 20

        // When
        try expectCalculation(
            sut.pressureChange(from: fromDepth, to: toDepth)) { result, configuration in
                // Then
                #expect(result.value == 1)
                #expect(result.unit == .atmospheres)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testAirVolumeFromSurfaceReturnsVolumeUnit() throws {
        // Given
        let depth: Depth = 20
        let volume: Volume = 6

        // When
        try expectCalculation(
            sut.airVolumeFromSurface(to: depth, with: volume)) { result, configuration in
                // Then
                #expect(result.value == 2)
                #expect(result.unit == .liters)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testAirVolumeToSurfaceReturnsVolumeUnit() throws {
        // Given
        let depth: Depth = 20
        let volume: Volume = 6

        // When
        try expectCalculation(
            sut.airVolumeToSurface(from: depth, with: volume)) { result, configuration in
                // Then
                #expect(result.value == 18)
                #expect(result.unit == .liters)
                #expect(configuration == sut.configuration)
            }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
    }
}
