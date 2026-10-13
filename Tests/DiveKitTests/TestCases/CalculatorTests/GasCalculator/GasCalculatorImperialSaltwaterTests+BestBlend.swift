import Testing
@testable import DiveKit

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

    @Test(.tags(.error))
    func bestBlendInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -111.0
            let partialPressure: PartialPressure<Oxygen> = 1.4
            self.expectedError = .negative(depth, "GasCalculator.bestBlend(for:partialPressure:using:)")
            return (depth: depth, partialPressure: partialPressure)
        } when: { input in
            Result { try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func bestBlendInvalidOxygenPartialPressureInput() async throws {
        try await given {
            let depth: Depth = 111.0
            let partialPressure: PartialPressure<Oxygen> = -1.4
            self.expectedError = .negative(partialPressure, "GasCalculator.bestBlend(for:partialPressure:using:)")
            return (depth: depth, partialPressure: partialPressure)
        } when: { input in
            Result { try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func bestBlendRejectsZeroOxygenPartialPressure() async throws {
        try await given {
            let depth: Depth = 111.0
            let partialPressure: PartialPressure<Oxygen> = 0
            self.expectedError = .range(
                .lowerBound(0, 0),
                "GasCalculator.bestBlend(for:partialPressure:using:)")
            return (depth: depth, partialPressure: partialPressure)
        } when: { input in
            Result { try self.sut.bestBlend(for: input.depth, partialPressure: input.partialPressure, using: self.physicsCalculator) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }
}
