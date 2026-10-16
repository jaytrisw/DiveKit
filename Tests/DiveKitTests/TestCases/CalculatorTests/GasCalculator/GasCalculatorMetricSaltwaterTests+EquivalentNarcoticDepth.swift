import Testing
@_spi(Experimental) @testable import DiveKit

extension GasCalculatorMetricSaltwaterTests {

    // MARK: equivalentNarcoticDepth(for:with:treating:)

    @Test(.tags(.technicalDiving))
    func metricSaltwaterEquivalentNarcoticDepth() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.equivalentNarcoticDepth(
                for: 60,
                with: .trimix(oxygen: 0.18, helium: 0.5))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(18.354430379746837))
            #expect(calculation.result.unit == .meters)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.technicalDiving))
    func metricSaltwaterEquivalentNarcoticDepthWithNarcoticOxygen() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.equivalentNarcoticDepth(
                for: 60,
                with: .trimix(oxygen: 0.18, helium: 0.5),
                treating: .narcotic(.oxygen))
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(25))
            #expect(calculation.result.unit == .meters)
        }
    }

    @Test(.tags(.technicalDiving), arguments: [Water.salt, .fresh], [0.0, 10.0, 40.0, 100.0])
    func metricEquivalentNarcoticDepthAirEqualsActualDepth(water: Water, depth: Depth) async throws {
        try await given {
            GasCalculator(.metric, water: water)
        } when: { sut in
            (oxygenNotNarcotic: try sut.equivalentNarcoticDepth(for: depth, with: .air),
             oxygenNarcotic: try sut.equivalentNarcoticDepth(for: depth, with: .air, treating: .narcotic(.oxygen)))
        } then: { _, calculations in
            #expect(calculations.oxygenNotNarcotic.result.value.isApproximately(depth.value))
            #expect(calculations.oxygenNarcotic.result.value.isApproximately(depth.value))
        }
    }
}
