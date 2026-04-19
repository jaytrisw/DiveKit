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
                expectEqual(result.value, 1)
                expectEqual(result.unit, .atmospheres)
                expectEqual(configuration, sut.configuration)
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
                expectEqual(result.value, 2)
                expectEqual(result.unit, .liters)
                expectEqual(configuration, sut.configuration)
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
                expectEqual(result.value, 18)
                expectEqual(result.unit, .liters)
                expectEqual(configuration, sut.configuration)
            }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
    }
}
