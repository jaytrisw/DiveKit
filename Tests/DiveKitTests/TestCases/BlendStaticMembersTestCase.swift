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
        expectEqual(oxygen.value, 0.209)
        expectEqual(oxygen.gas, .oxygen)
        expectEqual(nitrogen.value, 0.79)
        expectEqual(nitrogen.gas, .nitrogen)
        expectEqual(trace.value, 0.001)
        expectEqual(trace.gas, .trace)
        expectEqual(sut.totalPressure, 1.0)
        expectEqual(sut.components().count, 3)
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
        expectEqual(oxygen.value, oxygenFraction)
        expectEqual(oxygen.gas, .oxygen)
        expectEqual(nitrogen.value, 0.68, accuracy: 0.1)
        expectEqual(nitrogen.gas, .nitrogen)
        expectEqual(sut.totalPressure, 1.0)
        expectEqual(sut.components().count, 2)
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
                expectEqual($0.localizationKey, "dive.kit.error.negative.fractional.pressure")
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
