import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: equivalentAirDepth(for:with:)

    func testEquivalentAirDepthValidInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = Blend<Blended>.enrichedAir(0.4)

        // When
        try XCTAssertCalculation(
            sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
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
        try XCTAssertCalculation(
            sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
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
        expectedError = .negative(depth, "GasCalculator.equivalentAirDepth(for:with:)")

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
        let fractionalPressure = 0.4
        let blend = Blend<Unblended>(.init(.oxygen, fractionalPressure: 0.4))
        expectedError = .input(.blend(.totalPressure(fractionalPressure, blend)), "GasCalculator.equivalentAirDepth(for:with:)")

        // When
        try XCTAssertThrowsError(
            when: sut.equivalentAirDepth(for: depth, with: blend),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "blend.total.pressure")
            }
    }
}
