import Testing
@_spi(Experimental) @testable import DiveKit

extension GasCalculatorImperialSaltwaterTests {

    // MARK: equivalentNarcoticDepth(for:with:)

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthValidInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(75.9))
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthAirEqualsActualDepth() async throws {
        try await given {
            let depth: Depth = 100.0
            return (depth: depth, blend: Blend<Blended>.air)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, _ in
                #expect(result.value.isApproximately(100))
                #expect(result.unit == .feet)
            }
        }
    }

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthUnblendedValidInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Unblended>()
                .adding(.oxygen, pressure: 0.18)
                .adding(.helium, pressure: 0.45)
                .filling(with: .nitrogen)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(75.9))
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            self.expectedError = .negative(depth, "GasCalculator.equivalentNarcoticDepth(for:with:)")
            return (depth: depth, blend: blend)
        } when: { input in
            Result { try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthUnblendedInvalidBlendInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let fractionalPressure = 0.18
            let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: fractionalPressure))
            self.expectedError = .blend(.totalPressure(fractionalPressure, blend), "GasCalculator.equivalentNarcoticDepth(for:with:)")
            return (depth: depth, blend: blend)
        } when: { input in
            Result { try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
            }
        }
    }
}
