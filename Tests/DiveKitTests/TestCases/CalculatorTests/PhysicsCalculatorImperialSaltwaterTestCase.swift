import Testing
@testable import DiveKit

final class PhysicsCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<PhysicsCalculator> {

    var expectedError: Error!

    // MARK: gaugePressure(at:)

    @Test
    func testGaugePressureWithValidInput() throws {
        // Given
        let depth: Depth = 33.0

        // When
        try expectCalculation(
            sut.gaugePressure(at: depth)) { result, configuration in
                // Then
                #expect(result.value == 1)
                #expect(result.unit == .atmospheres)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testGaugePressureWithInvalidInput() throws {
        // Given
        let depth: Depth = -33.0
        expectedError = .negative(depth, "PhysicsCalculator.gaugePressure(at:)")

        // When
        try expectThrowsError(
            when: sut.gaugePressure(at: depth),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    // MARK: atmospheresAbsolute(at:)

    @Test
    func testAtmospheresAbsoluteWithValidInput() throws {
        // Given
        let depth: Depth = 33.0

        // When
        try expectCalculation(
            sut.atmospheresAbsolute(at: depth)) { result, configuration in
                // Then
                #expect(result.value == 2)
                #expect(result.unit == .atmospheres)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testAtmospheresAbsoluteWithInvalidInput() throws {
        // Given
        let depth: Depth = -33.0
        expectedError = .negative(depth, "PhysicsCalculator.atmospheresAbsolute(at:)")

        // When
        try expectThrowsError(
            when: sut.atmospheresAbsolute(at: depth),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    // MARK: pressureChange(from:to:)

    @Test
    func testPressureChangeWithValidInput() throws {
        // Given
        let fromDepth: Depth = 33.0
        let toDepth: Depth = 66.00

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
    func testPressureChangeWithInvalidFromDepthInput() throws {
        // Given
        let fromDepth: Depth = -33.0
        let toDepth: Depth = 66.00
        expectedError = .negative(fromDepth, "PhysicsCalculator.pressureChange(from:to:)")

        // When
        try expectThrowsError(
            when: sut.pressureChange(from: fromDepth, to: toDepth),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    @Test
    func testPressureChangeWithInvalidToDepthInput() throws {
        // Given
        let fromDepth: Depth = 33.0
        let toDepth: Depth = -66.00
        expectedError = .negative(toDepth, "PhysicsCalculator.pressureChange(from:to:)")

        // When
        try expectThrowsError(
            when: sut.pressureChange(from: fromDepth, to: toDepth),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    // MARK: airVolumeFromSurface(to:with:)

    @Test
    func testAirVolumeFromSurfaceWithValidInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = 6

        // When
        try expectCalculation(
            sut.airVolumeFromSurface(to: depth, with: volume)) { result, configuration in
                // Then
                #expect(result.value == 2)
                #expect(result.unit == .cubicFeet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testAirVolumeFromSurfaceWithInValidDepthInput() throws {
        // Given
        let depth: Depth = -66
        let volume: Volume = 6
        expectedError = .negative(depth, "PhysicsCalculator.airVolumeFromSurface(to:with:)")

        // When
        try expectThrowsError(
            when: sut.airVolumeFromSurface(to: depth, with: volume),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    @Test
    func testAirVolumeFromSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = -6
        expectedError = .negative(volume, "PhysicsCalculator.airVolumeFromSurface(to:with:)")

        // Then
        try expectThrowsError(
            when: sut.airVolumeFromSurface(to: depth, with: volume),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.volume")
            }
    }

    // MARK: airVolumeToSurface(from:with:)

    @Test
    func testAirVolumeToSurfaceWithValidInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = 6

        // When
        try expectCalculation(
            sut.airVolumeToSurface(from: depth, with: volume)) { result, configuration in
                // Then
                #expect(result.value == 18)
                #expect(result.unit == .cubicFeet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testAirVolumeToSurfaceWithInValidDepthInput() throws {
        // Given
        let depth: Depth = -66
        let volume: Volume = 6
        expectedError = .negative(depth, "PhysicsCalculator.airVolumeToSurface(from:with:)")

        // When
        try expectThrowsError(
            when: sut.airVolumeToSurface(from: depth, with: volume),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    @Test
    func testAirVolumeToSurfaceWithInValidVolumeInput() throws {
        // Given
        let depth: Depth = 66
        let volume: Volume = -6
        expectedError = .negative(volume, "PhysicsCalculator.airVolumeToSurface(from:with:)")

        // Then
        try expectThrowsError(
            when: sut.airVolumeToSurface(from: depth, with: volume),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.volume")
            }
    }

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
    }
}
