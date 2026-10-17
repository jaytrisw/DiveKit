import Testing
@testable import DiveKit

@Suite("Blend Static Members", .tags(.blend))
struct BlendStaticMembersTests {
    @Test
    func air() throws {
        let sut = Blend<Blended>.air

        let oxygen = try sut.fractionalPressure(of: .oxygen)
        let nitrogen = try sut.fractionalPressure(of: .nitrogen)

        #expect(oxygen.value == 0.21)
        #expect(oxygen.gas == .oxygen)
        #expect(nitrogen.value == 0.79)
        #expect(nitrogen.gas == .nitrogen)
        #expect(sut.totalPressure.isApproximately(1))
        #expect(sut.components().count == 2)
    }

    @Test
    func enrichedAir() throws {
        let oxygenFraction = 0.32
        let sut = try Blend<Blended>.enrichedAir(oxygenFraction)

        let oxygen = try sut.fractionalPressure(of: .oxygen)
        let nitrogen = try sut.fractionalPressure(of: .nitrogen)

        #expect(oxygen.value == oxygenFraction)
        #expect(oxygen.gas == .oxygen)
        #expect(nitrogen.value.isApproximately(0.68))
        #expect(nitrogen.gas == .nitrogen)
        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    @Test(.tags(.error))
    func enrichedAirRejectsNegativeFraction() throws {
        let fractionalPressure = -0.01
        let expectedError: Error = .negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        try expectThrowsError(
            when: try Blend.enrichedAir(fractionalPressure),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.fractional.pressure")
            }
    }

    @Test(.tags(.error))
    func enrichedAirRejectsFractionGreaterThanOne() throws {
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, .one),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        try expectThrowsError(
            when: try Blend.enrichedAir(fractionalPressure),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
    }

    @Test
    func enrichedAirAcceptsBoundaryValues() throws {
        _ = try Blend.enrichedAir(0.0)
        _ = try Blend.enrichedAir(1.0)
    }
}
