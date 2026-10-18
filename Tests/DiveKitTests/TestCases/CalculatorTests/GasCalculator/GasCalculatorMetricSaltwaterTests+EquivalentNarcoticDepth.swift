import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

extension GasCalculatorMetricSaltwaterTests {

    // MARK: equivalentNarcoticDepth(for:with:treating:)

    /// Tx 18/50 at 60 m, nitrogen only: (60 + 10) × 0.32 / 0.79 − 10 = 18.3544303797468354… m.
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

    /// Oxygen as narcotic as nitrogen: (60 + 10) × (0.32 + 0.18) / (0.79 + 0.21) − 10 = 25 m.
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
}
