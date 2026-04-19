import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: equivalentAirDepth(for:with:)

    @Test
    func testEquivalentAirDepthValidInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = try Blend<Blended>.enrichedAir(0.4)

        // When
        try expectCalculation(
            sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                expectEqual(result.value, 52.82278481012658)
                expectEqual(result.unit, .feet)
                expectEqual(configuration, sut.configuration)
            }
    }

    @Test
    func testEquivalentAirDepthUnblendedValidInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = try Blend<Unblended>()
            .adding(.oxygen, pressure: 0.4)
            .filling(with: .nitrogen)

        // When
        try expectCalculation(
            sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                expectEqual(result.value, 52.82278481012658)
                expectEqual(result.unit, .feet)
                expectEqual(configuration, sut.configuration)
            }
    }

    @Test
    func testEquivalentAirDepthInvalidDepthInput() throws {
        // Given
        let depth: Depth = -80.0
        let blend = try Blend<Blended>.enrichedAir(0.4)
        expectedError = .negative(depth, "GasCalculator.equivalentAirDepth(for:with:)")

        // When
        try expectThrowsError(
            when: sut.equivalentAirDepth(for: depth, with: blend),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.negative.depth")
            }
    }

    @Test
    func testEquivalentAirDepthUnblendedInvalidBlendInput() throws {
        // Given
        let depth: Depth = 80.0
        let fractionalPressure = 0.4
        let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: 0.4))
        expectedError = .blend(.totalPressure(fractionalPressure, blend), "GasCalculator.equivalentAirDepth(for:with:)")

        // When
        try expectThrowsError(
            when: sut.equivalentAirDepth(for: depth, with: blend),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.blend.total.pressure")
            }
    }
}
