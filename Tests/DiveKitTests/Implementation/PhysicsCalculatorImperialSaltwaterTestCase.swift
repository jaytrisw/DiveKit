import TestUtility
@testable import DiveKit

final class PhysicsCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<PhysicsCalculator> {

    // MARK: gaugePressure(at:)

    func testGaugePressureWithValidInput() throws {
        // Given
        let depth = 33.0

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
        let depth = -33.0

        // When
        XCTAssertThrowsError(try sut.gaugePressure(at: depth), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.gaugePressure(at:)")
        }
    }

    // MARK: atmospheresAbsolute(at:)

    func testAtmospheresAbsoluteWithValidInput() throws {
        // Given
        let depth = 33.0

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
        let depth = -33.0

        // When
        XCTAssertThrowsError(try sut.atmospheresAbsolute(at: depth), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.atmospheresAbsolute(at:)")
        }
    }

    // MARK: pressureChange(from:to:)

    func testPressureChangeWithValidInput() throws {
        // Given
        let fromDepth = 33.0
        let toDepth = 66.00

        // When
        let result = try sut.pressureChange(from: fromDepth, to: toDepth)

        // Then
        XCTAssertEqual(result.value, 1)
        XCTAssertEqual(result.unit, .psi)
        XCTAssertEqual(result.configuration, sut.configuration)
    }

    func testPressureChangeWithInvalidFromDepthInput() throws {
        // Given
        let fromDepth = -33.0
        let toDepth = 66.00

        // When
        XCTAssertThrowsError(try sut.pressureChange(from: fromDepth, to: toDepth), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, fromDepth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.pressureChange(from:to:)")
        }
    }

    func testPressureChangeWithInvalidToDepthInput() throws {
        // Given
        let fromDepth = 33.0
        let toDepth = -66.00

        // When
        XCTAssertThrowsError(try sut.pressureChange(from: fromDepth, to: toDepth), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, toDepth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.pressureChange(from:to:)")
        }
    }

    // MARK: airVolumeFromSurface(to:with:)

    func testAirVolumeFromSurfaceWithValidInput() throws {
        // Given
        let depth: Double = 66
        let volume: Double = 6

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
        let depth: Double = -66
        let volume: Double = 6

        // When
        XCTAssertThrowsError(try sut.airVolumeFromSurface(to: depth, with: volume), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
        }
    }

    func testAirVolumeFromSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Double = 66
        let volume: Double = -6

        // Then
        XCTAssertThrowsError(try sut.airVolumeFromSurface(to: depth, with: volume), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, volume)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.volume")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
        }
    }

    // MARK: airVolumeToSurface(from:with:)

    func testAirVolumeToSurfaceWithValidInput() throws {
        // Given
        let depth: Double = 66
        let volume: Double = 6

        // When
        let result = try sut.airVolumeToSurface(from: depth, with: volume)

        // Then
        XCTAssertEqual(result.value, 18)
        XCTAssertEqual(result.unit, .psi)
        XCTAssertEqual(result.configuration, sut.configuration)
    }

    func testAirVolumeToSurfaceWithInValidDepthInput() throws {
        // Given
        let depth: Double = -66
        let volume: Double = 6

        // When
        XCTAssertThrowsError(try sut.airVolumeToSurface(from: depth, with: volume), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.physics.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "PhysicsCalculator.airVolumeToSurface(from:with:)")
        }
    }

    func testAirVolumeToSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Double = 66
        let volume: Double = -6

        // Then
        XCTAssertThrowsError(try sut.airVolumeToSurface(from: depth, with: volume), as: Error<Double>.self) { error in
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

final class GasCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<GasCalculator> {

    func test() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth = 33.0

        // When
        XCTAssertCalculation(try sut.partialPressure(of: gas, in: blend, at: depth)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 0.42)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testM() throws {
        let fractionOxygen = 1.4
        let blend = Blend<Blended>.enrichedAir(0.32)

        // When
        XCTAssertCalculation(try sut.maximumOperatingDepth(for: fractionOxygen, in: blend)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 111.375)
            XCTAssertEqual(result.unit, .feet)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
    }
}

final class GasCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<GasCalculator> {

    func test() throws {
        // Given

        // When
        XCTAssertCalculation(
            try sut.surfaceAirConsumption(
                at: 15,
                for: 10,
                consuming: 40,
                using: sut.physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 1.6)
                    XCTAssertEqual(result.unit, .bar)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
    }
}
