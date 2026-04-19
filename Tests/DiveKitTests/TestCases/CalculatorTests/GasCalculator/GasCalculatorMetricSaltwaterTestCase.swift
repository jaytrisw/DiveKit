import Testing
@testable import DiveKit

final class GasCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<GasCalculator> {

    private var physicsCalculator: PhysicsCalculator!

    @Test
    func test() throws {
        // Given

        // When
        try expectCalculation(
            sut.surfaceAirConsumption(
                at: 15,
                for: 10,
                consuming: 40,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    #expect(result.value == 1.6)
                    #expect(result.unit == .perMinute(.bar))
                    #expect(configuration == sut.configuration)
                }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
        physicsCalculator = .init(.metric, water: .salt)
    }
}
