import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite("Physics Calculator", .tags(.physicsCalculator, .saltWater, .imperial))
struct PhysicsCalculatorImperialSaltwaterTests {

    // MARK: gaugePressure(at:)

    @Test
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

    @Test(.tags(.error))
    func imperialSaltwaterGaugePressureWithInvalidInput() async throws {
        try await given {
            let depth: Depth = -33.0
            let expectedError = Error.negative(depth, "PhysicsCalculator.gaugePressure(at:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, depth: depth, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.gaugePressure(at: input.depth) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    // MARK: atmospheresAbsolute(at:)

    @Test
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

    @Test(.tags(.error))
    func imperialSaltwaterAtmospheresAbsoluteWithInvalidInput() async throws {
        try await given {
            let depth: Depth = -33.0
            let expectedError = Error.negative(depth, "PhysicsCalculator.atmospheresAbsolute(at:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, depth: depth, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.atmospheresAbsolute(at: input.depth) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    // MARK: pressureChange(from:to:)

    @Test
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

    @Test(.tags(.error))
    func imperialSaltwaterPressureChangeWithInvalidFromDepthInput() async throws {
        try await given {
            let fromDepth: Depth = -33.0
            let toDepth: Depth = 66.00
            let expectedError = Error.negative(fromDepth, "PhysicsCalculator.pressureChange(from:to:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, fromDepth: fromDepth, toDepth: toDepth, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.pressureChange(from: input.fromDepth, to: input.toDepth) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func imperialSaltwaterPressureChangeWithInvalidToDepthInput() async throws {
        try await given {
            let fromDepth: Depth = 33.0
            let toDepth: Depth = -66.00
            let expectedError = Error.negative(toDepth, "PhysicsCalculator.pressureChange(from:to:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, fromDepth: fromDepth, toDepth: toDepth, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.pressureChange(from: input.fromDepth, to: input.toDepth) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    // MARK: airVolumeFromSurface(to:with:)

    @Test
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

    @Test(.tags(.error))
    func imperialSaltwaterAirVolumeFromSurfaceWithInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -66
            let volume: Volume = 6
            let expectedError = Error.negative(depth, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, depth: depth, volume: volume, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.airVolumeFromSurface(to: input.depth, with: input.volume) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func imperialSaltwaterAirVolumeFromSurfaceWithInvalidVolumeInput() async throws {
        try await given {
            let depth: Depth = 66
            let volume: Volume = -6
            let expectedError = Error.negative(volume, "PhysicsCalculator.airVolumeFromSurface(to:with:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, depth: depth, volume: volume, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.airVolumeFromSurface(to: input.depth, with: input.volume) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.volume")
            }
        }
    }

    // MARK: airVolumeToSurface(from:with:)

    @Test
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

    @Test(.tags(.error))
    func imperialSaltwaterAirVolumeToSurfaceWithInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -66
            let volume: Volume = 6
            let expectedError = Error.negative(depth, "PhysicsCalculator.airVolumeToSurface(from:with:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, depth: depth, volume: volume, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.airVolumeToSurface(from: input.depth, with: input.volume) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func imperialSaltwaterAirVolumeToSurfaceWithInvalidVolumeInput() async throws {
        try await given {
            let depth: Depth = 66
            let volume: Volume = -6
            let expectedError = Error.negative(volume, "PhysicsCalculator.airVolumeToSurface(from:with:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, depth: depth, volume: volume, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.airVolumeToSurface(from: input.depth, with: input.volume) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.volume")
            }
        }
    }

    // MARK: Non-finite input

    enum NonFiniteInput: CaseIterable, Sendable {
        case gaugePressureDepth
        case atmospheresAbsoluteDepth
        case pressureChangeFromDepth
        case pressureChangeToDepth
        case airVolumeFromSurfaceDepth
        case airVolumeFromSurfaceVolume
        case airVolumeToSurfaceDepth
        case airVolumeToSurfaceVolume

        var callSite: CallSite {
            switch self {
                case .gaugePressureDepth: "PhysicsCalculator.gaugePressure(at:)"
                case .atmospheresAbsoluteDepth: "PhysicsCalculator.atmospheresAbsolute(at:)"
                case .pressureChangeFromDepth, .pressureChangeToDepth: "PhysicsCalculator.pressureChange(from:to:)"
                case .airVolumeFromSurfaceDepth, .airVolumeFromSurfaceVolume: "PhysicsCalculator.airVolumeFromSurface(to:with:)"
                case .airVolumeToSurfaceDepth, .airVolumeToSurfaceVolume: "PhysicsCalculator.airVolumeToSurface(from:with:)"
            }
        }

        func run(with value: Double) throws {
            let sut = PhysicsCalculator(.imperial, water: .salt)
            switch self {
                case .gaugePressureDepth: _ = try sut.gaugePressure(at: .init(value))
                case .atmospheresAbsoluteDepth: _ = try sut.atmospheresAbsolute(at: .init(value))
                case .pressureChangeFromDepth: _ = try sut.pressureChange(from: .init(value), to: 66)
                case .pressureChangeToDepth: _ = try sut.pressureChange(from: 33, to: .init(value))
                case .airVolumeFromSurfaceDepth: _ = try sut.airVolumeFromSurface(to: .init(value), with: 6)
                case .airVolumeFromSurfaceVolume: _ = try sut.airVolumeFromSurface(to: 66, with: .init(value))
                case .airVolumeToSurfaceDepth: _ = try sut.airVolumeToSurface(from: .init(value), with: 6)
                case .airVolumeToSurfaceVolume: _ = try sut.airVolumeToSurface(from: 66, with: .init(value))
            }
        }
    }

    @Test(.tags(.error), arguments: NonFiniteInput.allCases, [Double.infinity, -.infinity])
    func imperialSaltwaterRejectsInfiniteInput(input: NonFiniteInput, value: Double) async throws {
        try await given {
            let expectedError: Error = .range(.upperBound(value, .greatestFiniteMagnitude), input.callSite)
            return (input: input, value: value, expectedError: expectedError)
        } when: { input in
            Result { try input.input.run(with: input.value) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error), arguments: NonFiniteInput.allCases)
    func imperialSaltwaterRejectsNaNInput(input: NonFiniteInput) async throws {
        try await given {
            input
        } when: { input in
            expectThrowsNaNUpperBound(when: try input.run(with: .nan), callSite: input.callSite)
        }
    }

    @Test(.tags(.error))
    func imperialSaltwaterAirVolumeToSurfaceRejectsOverflowingResult() async throws {
        try await given {
            let depth: Depth = 33
            let volume: Volume = .init(.greatestFiniteMagnitude)
            let expectedError = Error.range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "PhysicsCalculator.airVolumeToSurface(from:with:)")
            let sut = PhysicsCalculator(.imperial, water: .salt)
            return (sut: sut, depth: depth, volume: volume, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.airVolumeToSurface(from: input.depth, with: input.volume) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }
}
