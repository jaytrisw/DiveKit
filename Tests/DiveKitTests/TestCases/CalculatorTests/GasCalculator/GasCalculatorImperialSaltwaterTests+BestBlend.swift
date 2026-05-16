import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTests {

    // MARK: bestBlend(for:partialPressure:using:)

    @Test
    func bestBlendValidInput() async throws {
        try await given {
            let depth: Depth = 111.0
            let partialPressure: PartialPressure<Oxygen> = 1.4
            return {
                try expectCalculation(
                    self.sut.bestBlend(for: depth, partialPressure: partialPressure, using: self.physicsCalculator)) { result, configuration in
                        let oxygenFraction = try result.fractionalPressure(of: .oxygen)
                        #expect(oxygenFraction.value == 0.32)
                        #expect(configuration == self.sut.configuration)
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func bestBlendInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -111.0
            let partialPressure: PartialPressure<Oxygen> = 1.4
            self.expectedError = .negative(depth, "GasCalculator.bestBlend(for:partialPressure:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.bestBlend(for: depth, partialPressure: partialPressure, using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.depth")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func bestBlendInvalidOxygenPartialPressureInput() async throws {
        try await given {
            let depth: Depth = 111.0
            let partialPressure: PartialPressure<Oxygen> = -1.4
            self.expectedError = .negative(partialPressure, "GasCalculator.bestBlend(for:partialPressure:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.bestBlend(for: depth, partialPressure: partialPressure, using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.partial.pressure")
                    }
            }
        } when: { operation in
            try operation()
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
            return {
                try expectThrowsError(
                    when: self.sut.bestBlend(for: depth, partialPressure: partialPressure, using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
                    }
            }
        } when: { operation in
            try operation()
        }
    }
}
