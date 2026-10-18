import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

/// Checks results against worked examples published outside DiveKit, rounded
/// the way the source rounds them.
///
/// Sources:
/// - https://en.wikipedia.org/wiki/Equivalent_narcotic_depth
/// - https://en.wikipedia.org/wiki/Equivalent_air_depth
@Suite("Gas Calculator Published Examples", .tags(.gasCalculator, .saltWater))
struct GasCalculatorPublishedExampleTests {

    // MARK: equivalentNarcoticDepth(for:with:treating:)

    @Test(.tags(.technicalDiving, .metric))
    func equivalentNarcoticDepthMetricHelium40At60Meters() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.equivalentNarcoticDepth(
                for: 60,
                with: .trimix(oxygen: 0.21, helium: 0.4),
                treating: .narcotic(.oxygen))
        } then: { _, calculation in
            #expect(calculation.result.value.rounded() == 32)
            #expect(calculation.result.unit == .meters)
        }
    }

    @Test(.tags(.technicalDiving, .imperial))
    func equivalentNarcoticDepthImperialHelium40At200Feet() async throws {
        try await given {
            GasCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.equivalentNarcoticDepth(
                for: 200,
                with: .trimix(oxygen: 0.21, helium: 0.4),
                treating: .narcotic(.oxygen))
        } then: { _, calculation in
            #expect(calculation.result.value.rounded() == 107)
            #expect(calculation.result.unit == .feet)
        }
    }

    @Test(.tags(.metric))
    func equivalentNarcoticDepthWithoutNarcoticOxygenMatchesEquivalentAirDepth() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            (end: try sut.equivalentNarcoticDepth(for: 27, with: .enrichedAir(0.36)),
             ead: try sut.equivalentAirDepth(for: 27, with: .enrichedAir(0.36)))
        } then: { _, calculations in
            #expect(calculations.end.result.value.isApproximately(calculations.ead.result.value))
            #expect(calculations.end.result.value.rounded() == 20)
        }
    }

    // MARK: equivalentAirDepth(for:with:)

    @Test(.tags(.metric))
    func equivalentAirDepthMetricEAN36At27Meters() async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.equivalentAirDepth(for: 27, with: .enrichedAir(0.36))
        } then: { _, calculation in
            #expect(calculation.result.value.rounded() == 20)
            #expect(calculation.result.unit == .meters)
        }
    }

    @Test(.tags(.imperial))
    func equivalentAirDepthImperialEAN36At90Feet() async throws {
        try await given {
            GasCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.equivalentAirDepth(for: 90, with: .enrichedAir(0.36))
        } then: { _, calculation in
            #expect(calculation.result.value.rounded() == 67)
            #expect(calculation.result.unit == .feet)
        }
    }
}
