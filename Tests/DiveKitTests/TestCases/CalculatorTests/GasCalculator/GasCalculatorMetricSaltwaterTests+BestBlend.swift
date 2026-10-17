import Testing
@testable import DiveKit

extension GasCalculatorMetricSaltwaterTests {

    // MARK: bestBlend(for:partialPressure:using:)

    /// Metric salt water is 10 m per atmosphere, so each depth is a whole number
    /// of atmospheres and the expected fraction is the exact decimal quotient
    /// `partialPressure / ATA`, which is a whole percent in every row.
    @Test(arguments: [
        (depth: 40.0, partialPressure: 1.45, oxygenFraction: 0.29),
        (depth: 30.0, partialPressure: 1.16, oxygenFraction: 0.29),
        (depth: 20.0, partialPressure: 1.14, oxygenFraction: 0.38),
        (depth: 50.0, partialPressure: 1.14, oxygenFraction: 0.19)])
    func bestBlendKeepsExactWholePercent(depth: Double, partialPressure: Double, oxygenFraction: Double) async throws {
        try await given {
            GasCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.bestBlend(
                for: .init(depth),
                partialPressure: .init(partialPressure),
                using: PhysicsCalculator(.metric, water: .salt))
        } then: { sut, calculation in
            let oxygen = try calculation.result.fractionalPressure(of: .oxygen)
            #expect(oxygen.value.isApproximately(oxygenFraction))
            #expect(calculation.configuration == sut.configuration)
        }
    }
}
