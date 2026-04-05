import XCTest
@testable import DiveKit

final class BlendStaticMembersTestCase: SystemUnderTestCase<Blend<Blended>> {
    func testAir() throws {
        // Given
        sut = .air

        // When
        let oxygen = try sut.fraction(of: .oxygen)
        let nitrogen = try sut.fraction(of: .nitrogen)
        let trace = try sut.fraction(of: .trace)

        // Then
        XCTAssertEqual(oxygen.value, 0.209)
        XCTAssertEqual(oxygen.gas, .oxygen)
        XCTAssertEqual(nitrogen.value, 0.79)
        XCTAssertEqual(nitrogen.gas, .nitrogen)
        XCTAssertEqual(trace.value, 0.001)
        XCTAssertEqual(trace.gas, .trace)
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.components().count, 3)
    }

    func testEnrichedAir() throws {
        // Given
        let oxygenFraction = 0.32
        sut = try .enrichedAir(oxygenFraction)

        // When
        let oxygen = try sut.fraction(of: .oxygen)
        let nitrogen = try sut.fraction(of: .nitrogen)

        // Then
        XCTAssertEqual(oxygen.value, oxygenFraction)
        XCTAssertEqual(oxygen.gas, .oxygen)
        XCTAssertEqual(nitrogen.value, 0.68, accuracy: 0.1)
        XCTAssertEqual(nitrogen.gas, .nitrogen)
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.components().count, 2)
    }

    func testEnrichedAirRejectsNegativeFraction() throws {
        // Given
        let fractionalPressure = -0.01
        let expectedError: Error = .negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try XCTAssertThrowsError(
            when: try Blend.enrichedAir(fractionalPressure),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.fractional.pressure")
            }
    }

    func testEnrichedAirRejectsFractionGreaterThanOne() throws {
        // Given
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, .one),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try XCTAssertThrowsError(
            when: try Blend.enrichedAir(fractionalPressure),
            then: expectedError)
    }

    func testEnrichedAirAcceptsBoundaryValues() throws {
        XCTAssertNoThrow(try Blend.enrichedAir(0.0))
        XCTAssertNoThrow(try Blend.enrichedAir(1.0))
    }
}
