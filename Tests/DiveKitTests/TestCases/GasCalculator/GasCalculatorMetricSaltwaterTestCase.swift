import XCTest
@testable import DiveKit

final class GasCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<GasCalculator> {

    private var physicsCalculator: PhysicsCalculator!

    func test() throws {
        // Given

        // When
        XCTAssertCalculation(
            try sut.surfaceAirConsumption(
                at: 15,
                for: 10,
                consuming: 40,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.decimal.value, 1.6)
                    XCTAssertEqual(result.unit, .bar)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
        physicsCalculator = .init(.metric, water: .salt)
    }
}

