import Testing
@testable import DiveKit
import DiveKitTestSupport

extension GasCalculatorImperialSaltwaterTests {

    // MARK: bestBlend(for:partialPressure:using:)

    @Test
    func bestBlendValidInput() async throws {
        try await given {
            let depth: Depth = 111.0
            let partialPressure: PartialPressure<Oxygen> = 1.4
            return (depth: depth, partialPressure: partialPressure)
        } when: { input in
            try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                let oxygenFraction = try result.fractionalPressure(of: .oxygen)
                #expect(oxygenFraction.value == 0.32)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    /// At 10 ft, 1.4 / (1 + 10 / 33) = 1.0745, so no enriched air reaches the
    /// target and pure oxygen is the richest mix.
    @Test
    func bestBlendClampsToOxygenWhenShallow() async throws {
        try await given {
            let depth: Depth = 10.0
            let partialPressure: PartialPressure<Oxygen> = 1.4
            return (depth: depth, partialPressure: partialPressure)
        } when: { input in
            try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                let oxygen = try result.fractionalPressure(of: .oxygen)
                let nitrogen = try result.fractionalPressure(of: .nitrogen)
                #expect(oxygen.value == 1)
                #expect(nitrogen.value == 0)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    /// At the surface, 0.005 / 1 = 0.5%, which rounds down to a blend with no oxygen.
    @Test(.tags(.error))
    func bestBlendRejectsFractionRoundingToZero() async throws {
        try await given {
            let depth: Depth = 0
            let partialPressure: PartialPressure<Oxygen> = 0.005
            let expectedError: Error = .range(
                .lowerBound(0, 0),
                "GasCalculator.bestBlend(for:partialPressure:using:)")
            return (depth: depth, partialPressure: partialPressure, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.error))
    func bestBlendInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -111.0
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let expectedError: Error = .negative(depth, "GasCalculator.bestBlend(for:partialPressure:using:)")
            return (depth: depth, partialPressure: partialPressure, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func bestBlendInvalidOxygenPartialPressureInput() async throws {
        try await given {
            let depth: Depth = 111.0
            let partialPressure: PartialPressure<Oxygen> = -1.4
            let expectedError: Error = .negative(partialPressure, "GasCalculator.bestBlend(for:partialPressure:using:)")
            return (depth: depth, partialPressure: partialPressure, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func bestBlendRejectsZeroOxygenPartialPressure() async throws {
        try await given {
            let depth: Depth = 111.0
            let partialPressure: PartialPressure<Oxygen> = 0
            let expectedError: Error = .range(
                .lowerBound(0, 0),
                "GasCalculator.bestBlend(for:partialPressure:using:)")
            return (depth: depth, partialPressure: partialPressure, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }
}
