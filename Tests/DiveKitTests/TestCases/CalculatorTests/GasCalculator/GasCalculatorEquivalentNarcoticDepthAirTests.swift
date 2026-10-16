import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Gas Calculator Air END", .tags(.gasCalculator, .metric, .technicalDiving))
struct GasCalculatorEquivalentNarcoticDepthAirTests {

    // MARK: equivalentNarcoticDepth(for:with:treating:)

    @Test(.tags(.saltWater), arguments: [0.0, 10.0, 40.0, 100.0])
    func saltwaterAirEqualsActualDepth(depth: Depth) async throws {
        try await expectAirEqualsActualDepth(depth, in: .salt)
    }

    @Test(.tags(.freshWater), arguments: [0.0, 10.0, 40.0, 100.0])
    func freshwaterAirEqualsActualDepth(depth: Depth) async throws {
        try await expectAirEqualsActualDepth(depth, in: .fresh)
    }

    private func expectAirEqualsActualDepth(_ depth: Depth, in water: Water) async throws {
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
