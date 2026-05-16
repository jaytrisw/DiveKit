import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: equivalentAirDepth(for:with:)

    @Test
    func equivalentAirDepthValidInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = try Blend<Blended>.enrichedAir(0.4)

        // When
        try expectCalculation(
            sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                #expect(result.value == 52.82278481012658)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func equivalentAirDepthUnblendedValidInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = try Blend<Unblended>()
            .adding(.oxygen, pressure: 0.4)
            .filling(with: .nitrogen)

        // When
        try expectCalculation(
            sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                #expect(result.value == 52.82278481012658)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test(.tags(.error))
    func equivalentAirDepthInvalidDepthInput() throws {
        // Given
        let depth: Depth = -80.0
        let blend = try Blend<Blended>.enrichedAir(0.4)
        expectedError = .negative(depth, "GasCalculator.equivalentAirDepth(for:with:)")

        // When
        try expectThrowsError(
            when: sut.equivalentAirDepth(for: depth, with: blend),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
    }

    @Test(.tags(.error))
    func equivalentAirDepthUnblendedInvalidBlendInput() throws {
        // Given
        let depth: Depth = 80.0
        let fractionalPressure = 0.4
        let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: 0.4))
        expectedError = .blend(.totalPressure(fractionalPressure, blend), "GasCalculator.equivalentAirDepth(for:with:)")

        // When
        try expectThrowsError(
            when: sut.equivalentAirDepth(for: depth, with: blend),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
            }
    }
}
