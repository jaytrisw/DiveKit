import XCTest
@testable import DiveKit

final class PhysicsCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<PhysicsCalculator> {

    func testPressureChangeReturnsAtmospheresDelta() throws {
        // Given
        let fromDepth: Depth = 10
        let toDepth: Depth = 20

        // When
        try XCTAssertCalculation(
            sut.pressureChange(from: fromDepth, to: toDepth)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 1)
                XCTAssertEqual(result.unit, .atmospheres)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testAirVolumeFromSurfaceReturnsVolumeUnit() throws {
        // Given
        let depth: Depth = 20
        let volume: Volume = 6

        // When
        try XCTAssertCalculation(
            sut.airVolumeFromSurface(to: depth, with: volume)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 2)
                XCTAssertEqual(result.unit, .liters)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testAirVolumeToSurfaceReturnsVolumeUnit() throws {
        // Given
        let depth: Depth = 20
        let volume: Volume = 6

        // When
        try XCTAssertCalculation(
            sut.airVolumeToSurface(from: depth, with: volume)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 18)
                XCTAssertEqual(result.unit, .liters)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
    }
}
