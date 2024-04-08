import XCTest
@testable import DiveKit

final class PhysicsCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<PhysicsCalculator> {

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

        // When
        XCTAssertThrowsError(try sut.gaugePressure(at: depth), as: Error<Depth>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.gaugePressure(at:)")
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

        // When
        XCTAssertThrowsError(try sut.atmospheresAbsolute(at: depth), as: Error<Depth>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.atmospheresAbsolute(at:)")
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

        // When
        XCTAssertThrowsError(try sut.pressureChange(from: fromDepth, to: toDepth), as: Error<Depth>.self) { error in
            // Then
            XCTAssertEqual(error.value, fromDepth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.pressureChange(from:to:)")
        }
    }

    func testPressureChangeWithInvalidToDepthInput() throws {
        // Given
        let fromDepth: Depth = 33.0
        let toDepth: Depth = -66.00

        // When
        XCTAssertThrowsError(try sut.pressureChange(from: fromDepth, to: toDepth), as: Error<Depth>.self) { error in
            // Then
            XCTAssertEqual(error.value, toDepth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.pressureChange(from:to:)")
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

        // When
        XCTAssertThrowsError(try sut.airVolumeFromSurface(to: depth, with: volume), as: Error<Depth>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
        }
    }

    func testAirVolumeFromSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = -6

        // Then
        XCTAssertThrowsError(try sut.airVolumeFromSurface(to: depth, with: volume), as: Error<Volume>.self) { error in
            // Then
            XCTAssertEqual(error.value, volume)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.volume")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
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

        // When
        XCTAssertThrowsError(try sut.airVolumeToSurface(from: depth, with: volume), as: Error<Depth>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.airVolumeToSurface(from:with:)")
        }
    }

    func testAirVolumeToSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = -6

        // Then
        XCTAssertThrowsError(try sut.airVolumeToSurface(from: depth, with: volume), as: Error<Volume>.self) { error in
            // Then
            XCTAssertEqual(error.value, volume)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.volume")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.airVolumeToSurface(from:with:)")
        }
    }

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
    }
}
