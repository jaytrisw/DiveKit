import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

@Suite("Blend Trimix", .tags(.blend, .technicalDiving))
struct BlendTrimixTests {
    @Test
    func trimix() throws {
        let sut = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)

        let oxygen = try sut.fractionalPressure(of: .oxygen)
        let helium = try sut.fractionalPressure(of: .helium)
        let nitrogen = try sut.fractionalPressure(of: .nitrogen)

        #expect(oxygen.value == 0.18)
        #expect(oxygen.gas == .oxygen)
        #expect(helium.value == 0.45)
        #expect(helium.gas == .helium)
        #expect(nitrogen.value.isApproximately(0.37))
        #expect(nitrogen.gas == .nitrogen)
        #expect(sut.totalPressure.isApproximately(1.0))
        #expect(sut.components().count == 3)
    }

    @Test
    func trimixAcceptsFractionsSummingToOne() throws {
        let sut = try Blend<Blended>.trimix(oxygen: 0.8, helium: 0.2)

        #expect(try sut.fractionalPressure(of: .nitrogen).value == 0)
        #expect(sut.totalPressure == 1.0)
    }

    @Test
    func trimixAcceptsBoundaryValues() throws {
        _ = try Blend<Blended>.trimix(oxygen: 0.0, helium: 0.0)
        _ = try Blend<Blended>.trimix(oxygen: 1.0, helium: 0.0)
        _ = try Blend<Blended>.trimix(oxygen: 0.0, helium: 1.0)
    }

    @Test(.tags(.error))
    func trimixRejectsNegativeOxygen() throws {
        let fractionalPressure = -0.01
        let expectedError: Error = .negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        try expectThrowsError(
            when: try Blend.trimix(oxygen: fractionalPressure, helium: 0.5),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.fractional.pressure")
            }
    }

    @Test(.tags(.error))
    func trimixRejectsNegativeHelium() throws {
        let fractionalPressure = -0.01
        let expectedError: Error = .negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Helium>.init(of:fractionalPressure:)")

        try expectThrowsError(
            when: try Blend.trimix(oxygen: 0.21, helium: fractionalPressure),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.fractional.pressure")
            }
    }

    @Test(.tags(.error))
    func trimixRejectsOxygenGreaterThanOne() throws {
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, .one),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        try expectThrowsError(
            when: try Blend.trimix(oxygen: fractionalPressure, helium: 0.0),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
    }

    @Test(.tags(.error))
    func trimixRejectsHeliumGreaterThanOne() throws {
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, .one),
            "FractionalPressure<Helium>.init(of:fractionalPressure:)")

        try expectThrowsError(
            when: try Blend.trimix(oxygen: 0.0, helium: fractionalPressure),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
    }

    @Test(.tags(.error))
    func trimixRejectsFractionsExceedingOne() throws {
        let oxygen = 0.7
        let helium = 0.4
        let expectedError: Error = .range(
            .upperBound(oxygen + helium, .one),
            "Blend<Blended>.trimix(oxygen:helium:)")

        try expectThrowsError(
            when: try Blend.trimix(oxygen: oxygen, helium: helium),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
    }
}
