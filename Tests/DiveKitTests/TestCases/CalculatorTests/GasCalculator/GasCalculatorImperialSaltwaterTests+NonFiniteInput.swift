import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

extension GasCalculatorImperialSaltwaterTests {

    // MARK: Non-finite input

    struct NonFiniteInput: Sendable, CustomTestStringConvertible {
        let testDescription: String
        let callSite: CallSite
        let run: @Sendable (_ value: Double, _ sut: GasCalculator, _ physicsCalculator: PhysicsCalculator) throws -> Void

        static let all: [Self] = [
            .init(testDescription: "bestBlend depth", callSite: "GasCalculator.bestBlend(for:partialPressure:using:)") { value, sut, physicsCalculator in
                _ = try sut.bestBlend(for: .init(value), partialPressure: 1.4, using: physicsCalculator)
            },
            .init(testDescription: "bestBlend partialPressure", callSite: "GasCalculator.bestBlend(for:partialPressure:using:)") { value, sut, physicsCalculator in
                _ = try sut.bestBlend(for: 111, partialPressure: .init(value), using: physicsCalculator)
            },
            .init(testDescription: "equivalentAirDepth depth", callSite: "GasCalculator.equivalentAirDepth(for:with:)") { value, sut, _ in
                _ = try sut.equivalentAirDepth(for: .init(value), with: .air)
            },
            .init(testDescription: "equivalentNarcoticDepth depth", callSite: "GasCalculator.equivalentNarcoticDepth(for:with:treating:)") { value, sut, _ in
                _ = try sut.equivalentNarcoticDepth(for: .init(value), with: .air)
            },
            .init(testDescription: "maximumOperatingDepth partialPressure", callSite: "GasCalculator.maximumOperatingDepth(for:in:)") { value, sut, _ in
                _ = try sut.maximumOperatingDepth(for: .init(value), in: .air)
            },
            .init(testDescription: "partialPressure depth", callSite: "GasCalculator.partialPressure(of:in:at:using:)") { value, sut, physicsCalculator in
                _ = try sut.partialPressure(of: Oxygen(), in: .air, at: .init(value), using: physicsCalculator)
            },
            .init(testDescription: "surfaceAirConsumption start", callSite: "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)") { value, sut, physicsCalculator in
                _ = try sut.surfaceAirConsumption(at: 90, for: 10, start: .init(value), end: 2400, using: physicsCalculator)
            },
            .init(testDescription: "surfaceAirConsumption end", callSite: "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)") { value, sut, physicsCalculator in
                _ = try sut.surfaceAirConsumption(at: 90, for: 10, start: 3000, end: .init(value), using: physicsCalculator)
            },
            .init(testDescription: "surfaceAirConsumption depth", callSite: "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)") { value, sut, physicsCalculator in
                _ = try sut.surfaceAirConsumption(at: .init(value), for: 10, consuming: 600, using: physicsCalculator)
            },
            .init(testDescription: "surfaceAirConsumption minutes", callSite: "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)") { value, sut, physicsCalculator in
                _ = try sut.surfaceAirConsumption(at: 90, for: .init(value), consuming: 600, using: physicsCalculator)
            },
            .init(testDescription: "surfaceAirConsumption consuming", callSite: "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)") { value, sut, physicsCalculator in
                _ = try sut.surfaceAirConsumption(at: 90, for: 10, consuming: .init(value), using: physicsCalculator)
            },
            .init(testDescription: "respiratoryMinuteVolume tank volume", callSite: "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)") { value, sut, physicsCalculator in
                _ = try sut.respiratoryMinuteVolume(at: 90, for: 10, consuming: 600, with: .cubicFeet(.init(value), ratedPressure: 2475, with: .air), using: physicsCalculator)
            },
            .init(testDescription: "respiratoryMinuteVolume rated pressure", callSite: "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)") { value, sut, physicsCalculator in
                _ = try sut.respiratoryMinuteVolume(at: 90, for: 10, consuming: 600, with: .cubicFeet(142, ratedPressure: .init(value), with: .air), using: physicsCalculator)
            }
        ]
    }

    @Test(.tags(.error), arguments: NonFiniteInput.all, [Double.infinity, -.infinity])
    func rejectsInfiniteInput(input: NonFiniteInput, value: Double) async throws {
        try await given {
            let expectedError: Error = .range(.upperBound(value, .greatestFiniteMagnitude), input.callSite)
            return (input: input, value: value, expectedError: expectedError)
        } when: { input in
            Result { try input.input.run(input.value, self.sut, self.physicsCalculator) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error), arguments: NonFiniteInput.all)
    func rejectsNaNInput(input: NonFiniteInput) async throws {
        try await given {
            input
        } when: { input in
            expectThrowsNaNUpperBound(when: try input.run(.nan, self.sut, self.physicsCalculator), callSite: input.callSite)
        }
    }

    // MARK: Overflowing results

    @Test(.tags(.error))
    func maximumOperatingDepthRejectsOverflowingResult() async throws {
        try await given {
            let partialPressure = PartialPressure<Oxygen>(.greatestFiniteMagnitude)
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "GasCalculator.maximumOperatingDepth(for:in:)")
            return (partialPressure: partialPressure, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.maximumOperatingDepth(for: input.partialPressure, in: .air) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error))
    func equivalentAirDepthRejectsOverflowingResult() async throws {
        try await given {
            let depth = Depth(.greatestFiniteMagnitude)
            let blend = try Blend<Blended>.enrichedAir(0.1)
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "GasCalculator.equivalentAirDepth(for:with:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.equivalentAirDepth(for: input.depth, with: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionRejectsOverflowingResult() async throws {
        try await given {
            let consuming = Pressure(.greatestFiniteMagnitude)
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return (consuming: consuming, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.surfaceAirConsumption(at: 90, for: 0.5, consuming: input.consuming, using: self.physicsCalculator) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }
}
