import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: equivalentAirDepth(for:with:)

    func testEquivalentAirDepthValidInput() {
        // Given
        let depth: Depth = 80.0
        let blend = Blend<Blended>.enrichedAir(0.4)

        // When
        XCTAssertCalculation(
            try sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 52.82278481012658)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testEquivalentAirDepthUnblendedValidInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = try Blend<Unblended>()
            .adding(.oxygen, pressure: 0.4)
            .filling(with: .nitrogen)

        // When
        XCTAssertCalculation(
            try sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 52.82278481012658)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testEquivalentAirDepthInvalidDepthInput() throws {
        // Given
        let depth: Depth = -80.0
        let blend = Blend<Blended>.enrichedAir(0.4)
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.equivalentAirDepth(for:with:)")

        // When
        try XCTAssertThrowsError(
            when: sut.equivalentAirDepth(for: depth, with: blend),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    func testEquivalentAirDepthUnblendedInvalidBlendInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = Blend<Unblended>(.init(.oxygen, fractionalPressure: 0.4))
        expectedError = .input(.invalid(.blend(blend)), "GasCalculator.equivalentAirDepth(for:with:)")

        // When
        try XCTAssertThrowsError(
            when: sut.equivalentAirDepth(for: depth, with: blend),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "invalid.blend")
            }
    }
}
