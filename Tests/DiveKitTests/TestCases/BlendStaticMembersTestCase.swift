import Testing
@testable import DiveKit

final class BlendStaticMembersTestCase: SystemUnderTestCase<Blend<Blended>> {
    @Test
    func testAir() throws {
        // Given
        sut = .air

        // When
        let oxygen = try sut.fractionalPressure(of: .oxygen)
        let nitrogen = try sut.fractionalPressure(of: .nitrogen)
        let trace = try sut.fractionalPressure(of: .trace)

        // Then
        #expect(oxygen.value == 0.209)
        #expect(oxygen.gas == .oxygen)
        #expect(nitrogen.value == 0.79)
        #expect(nitrogen.gas == .nitrogen)
        #expect(trace.value == 0.001)
        #expect(trace.gas == .trace)
        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 3)
    }

    @Test
    func testEnrichedAir() throws {
        // Given
        let oxygenFraction = 0.32
        sut = try .enrichedAir(oxygenFraction)

        // When
        let oxygen = try sut.fractionalPressure(of: .oxygen)
        let nitrogen = try sut.fractionalPressure(of: .nitrogen)

        // Then
        #expect(oxygen.value == oxygenFraction)
        #expect(oxygen.gas == .oxygen)
        #expect(abs(nitrogen.value - 0.68) <= 0.1)
        #expect(nitrogen.gas == .nitrogen)
        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    @Test
    func testEnrichedAirRejectsNegativeFraction() throws {
        // Given
        let fractionalPressure = -0.01
        let expectedError: Error = .negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try expectThrowsError(
            when: try Blend.enrichedAir(fractionalPressure),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.fractional.pressure")
            }
    }

    @Test
    func testEnrichedAirRejectsFractionGreaterThanOne() throws {
        // Given
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, .one),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try expectThrowsError(
            when: try Blend.enrichedAir(fractionalPressure),
            then: expectedError)
    }

    @Test
    func testEnrichedAirAcceptsBoundaryValues() throws {
        _ = try Blend.enrichedAir(0.0)
        _ = try Blend.enrichedAir(1.0)
    }
}
