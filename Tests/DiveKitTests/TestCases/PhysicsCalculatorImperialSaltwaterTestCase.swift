import XCTest
@testable import DiveKit

final class PhysicsCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<PhysicsCalculator> {

    var expectedError: Error!

    // MARK: gaugePressure(at:)

    func testGaugePressureWithValidInput() throws {
        // Given
        let depth: Depth = 33.0

        // When
        XCTAssertCalculation(try sut.gaugePressure(at: depth)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 1)
            XCTAssertEqual(result.unit, .atmospheres)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testGaugePressureWithInvalidInput() throws {
        // Given
        let depth: Depth = -33.0
        expectedError = .input(.negative(.depth(depth)), "PhysicsCalculator.gaugePressure(at:)")

        // When
        try XCTAssertThrowsError(
            when: sut.gaugePressure(at: depth),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    // MARK: atmospheresAbsolute(at:)

    func testAtmospheresAbsoluteWithValidInput() throws {
        // Given
        let depth: Depth = 33.0

        // When
        XCTAssertCalculation(try sut.atmospheresAbsolute(at: depth)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 2)
            XCTAssertEqual(result.unit, .atmospheres)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testAtmospheresAbsoluteWithInvalidInput() throws {
        // Given
        let depth: Depth = -33.0
        expectedError = .input(.negative(.depth(depth)), "PhysicsCalculator.atmospheresAbsolute(at:)")

        // When
        try XCTAssertThrowsError(
            when: sut.atmospheresAbsolute(at: depth),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    // MARK: pressureChange(from:to:)

    func testPressureChangeWithValidInput() throws {
        // Given
        let fromDepth: Depth = 33.0
        let toDepth: Depth = 66.00

        // When
        XCTAssertCalculation(try sut.pressureChange(from: fromDepth, to: toDepth)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 1)
            XCTAssertEqual(result.unit, .psi)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testPressureChangeWithInvalidFromDepthInput() throws {
        // Given
        let fromDepth: Depth = -33.0
        let toDepth: Depth = 66.00
        expectedError = .input(.negative(.depth(fromDepth)), "PhysicsCalculator.pressureChange(from:to:)")

        // When
        try XCTAssertThrowsError(
            when: sut.pressureChange(from: fromDepth, to: toDepth),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    func testPressureChangeWithInvalidToDepthInput() throws {
        // Given
        let fromDepth: Depth = 33.0
        let toDepth: Depth = -66.00
        expectedError = .input(.negative(.depth(toDepth)), "PhysicsCalculator.pressureChange(from:to:)")

        // When
        try XCTAssertThrowsError(
            when: sut.pressureChange(from: fromDepth, to: toDepth),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    // MARK: airVolumeFromSurface(to:with:)

    func testAirVolumeFromSurfaceWithValidInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = 6

        // When
        XCTAssertCalculation(try sut.airVolumeFromSurface(to: depth, with: volume)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 2)
            XCTAssertEqual(result.unit, .psi)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testAirVolumeFromSurfaceWithInValidDepthInput() throws {
        // Given
        let depth: Depth = -66
        let volume: Volume = 6
        expectedError = .input(.negative(.depth(depth)), "PhysicsCalculator.airVolumeFromSurface(to:with:)")

        // When
        try XCTAssertThrowsError(
            when: sut.airVolumeFromSurface(to: depth, with: volume),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    func testAirVolumeFromSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = -6
        expectedError = .input(.negative(.volume(volume)), "PhysicsCalculator.airVolumeFromSurface(to:with:)")

        // Then
        try XCTAssertThrowsError(
            when: sut.airVolumeFromSurface(to: depth, with: volume),
            then: expectedError) {
                    XCTAssertEqual($0.localizationKey, "negative.volume")
                }
    }

    // MARK: airVolumeToSurface(from:with:)

    func testAirVolumeToSurfaceWithValidInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = 6

        // When
        XCTAssertCalculation(try sut.airVolumeToSurface(from: depth, with: volume)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 18)
            XCTAssertEqual(result.unit, .psi)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testAirVolumeToSurfaceWithInValidDepthInput() throws {
        // Given
        let depth: Depth = -66
        let volume: Volume = 6
        expectedError = .input(.negative(.depth(depth)), "PhysicsCalculator.airVolumeToSurface(from:with:)")

        // When
        try XCTAssertThrowsError(
            when: sut.airVolumeToSurface(from: depth, with: volume),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    func testAirVolumeToSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = -6
        expectedError = .input(.negative(.volume(volume)), "PhysicsCalculator.airVolumeToSurface(from:with:)")

        // Then
        try XCTAssertThrowsError(
            when: sut.airVolumeToSurface(from: depth, with: volume),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.volume")
            }
    }

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
    }
}
