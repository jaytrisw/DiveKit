import Testing
@testable import DiveKit

@Suite("Physics Calculator", .tags(.physicsCalculator))
struct PhysicsCalculatorImperialSaltwaterTestCase {

    // MARK: gaugePressure(at:)

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterGaugePressureWithValidInput() async throws {
        try await given {
            PhysicsCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.gaugePressure(at: Depth(33))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(1))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterGaugePressureWithInvalidInput() throws {
        let depth: Depth = -33.0
        let expectedError = Error.negative(depth, "PhysicsCalculator.gaugePressure(at:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.gaugePressure(at: depth)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.depth")
        }
    }

    // MARK: atmospheresAbsolute(at:)

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAtmospheresAbsoluteWithValidInput() async throws {
        try await given {
            PhysicsCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.atmospheresAbsolute(at: Depth(33))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(2))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAtmospheresAbsoluteWithInvalidInput() throws {
        let depth: Depth = -33.0
        let expectedError = Error.negative(depth, "PhysicsCalculator.atmospheresAbsolute(at:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.atmospheresAbsolute(at: depth)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.depth")
        }
    }

    // MARK: pressureChange(from:to:)

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterPressureChangeWithValidInput() async throws {
        try await given {
            PhysicsCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.pressureChange(from: Depth(33), to: Depth(66))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(1))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterPressureChangeWithInvalidFromDepthInput() throws {
        let fromDepth: Depth = -33.0
        let toDepth: Depth = 66.00
        let expectedError = Error.negative(fromDepth, "PhysicsCalculator.pressureChange(from:to:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.pressureChange(from: fromDepth, to: toDepth)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.depth")
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterPressureChangeWithInvalidToDepthInput() throws {
        let fromDepth: Depth = 33.0
        let toDepth: Depth = -66.00
        let expectedError = Error.negative(toDepth, "PhysicsCalculator.pressureChange(from:to:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.pressureChange(from: fromDepth, to: toDepth)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.depth")
        }
    }

    // MARK: airVolumeFromSurface(to:with:)

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAirVolumeFromSurfaceWithValidInput() async throws {
        try await given {
            PhysicsCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.airVolumeFromSurface(to: Depth(66), with: Volume(6))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(2))
            #expect(calculation.result.unit == .cubicFeet)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAirVolumeFromSurfaceWithInvalidDepthInput() throws {
        let depth: Depth = -66
        let volume: Volume = 6
        let expectedError = Error.negative(depth, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.airVolumeFromSurface(to: depth, with: volume)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.depth")
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAirVolumeFromSurfaceWithInvalidVolumeInput() throws {
        let depth: Depth = 66
        let volume: Volume = -6
        let expectedError = Error.negative(volume, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.airVolumeFromSurface(to: depth, with: volume)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.volume")
        }
    }

    // MARK: airVolumeToSurface(from:with:)

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAirVolumeToSurfaceWithValidInput() async throws {
        try await given {
            PhysicsCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.airVolumeToSurface(from: Depth(66), with: Volume(6))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(18))
            #expect(calculation.result.unit == .cubicFeet)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAirVolumeToSurfaceWithInvalidDepthInput() throws {
        let depth: Depth = -66
        let volume: Volume = 6
        let expectedError = Error.negative(depth, "PhysicsCalculator.airVolumeToSurface(from:with:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.airVolumeToSurface(from: depth, with: volume)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.depth")
        }
    }

    @Test(.tags(.saltWater, .imperial))
    func imperialSaltwaterAirVolumeToSurfaceWithInvalidVolumeInput() throws {
        let depth: Depth = 66
        let volume: Volume = -6
        let expectedError = Error.negative(volume, "PhysicsCalculator.airVolumeToSurface(from:with:)")
        let sut = PhysicsCalculator(.imperial, water: .salt)

        do {
            _ = try sut.airVolumeToSurface(from: depth, with: volume)
            Issue.record("Expected an error to be thrown.")
        } catch let error {
            #expect(error == expectedError)
            #expect(error.localizationKey == "dive.kit.error.negative.volume")
        }
    }
}
