import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTests {

    // MARK: equivalentAirDepth(for:with:)

    @Test
    func equivalentAirDepthValidInput() async throws {
        try await given {
            let depth: Depth = 80.0
            let blend = try Blend<Blended>.enrichedAir(0.4)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentAirDepth(for: input.depth, with: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value == 52.82278481012658)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func equivalentAirDepthUnblendedValidInput() async throws {
        try await given {
            let depth: Depth = 80.0
            let blend = try Blend<Unblended>()
                .adding(.oxygen, pressure: 0.4)
                .filling(with: .nitrogen)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentAirDepth(for: input.depth, with: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value == 52.82278481012658)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func equivalentAirDepthInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -80.0
            let blend = try Blend<Blended>.enrichedAir(0.4)
            let expectedError: Error = .negative(depth, "GasCalculator.equivalentAirDepth(for:with:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.equivalentAirDepth(for: input.depth, with: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func equivalentAirDepthUnblendedInvalidBlendInput() async throws {
        try await given {
            let depth: Depth = 80.0
            let fractionalPressure = 0.4
            let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: 0.4))
            let expectedError: Error = .blend(.totalPressure(fractionalPressure, blend), "GasCalculator.equivalentAirDepth(for:with:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.equivalentAirDepth(for: input.depth, with: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
            }
        }
    }
}
