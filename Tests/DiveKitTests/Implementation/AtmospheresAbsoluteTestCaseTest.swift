import TestUtility
@testable import DiveKit

final class AtmospheresAbsoluteTestCaseTest: ThrowingMethodUnderTestCase<PhysicsCalculator, Double, Calculation<Double, Units.Pressure>> {

    func testMetricSaltwater() throws {
        // Given
        sut = .init(.metric, water: .salt)
        mut = sut.atmospheresAbsolute(at:)
        data = [
            .init(input: 0.0, output: .init(value: 1, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 10, output: .init(value: 2, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 20, output: .init(value: 3, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 30, output: .init(value: 4, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 40, output: .init(value: 5, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 38.5, output: .init(value: 4.85, unit: .atmospheres, configuration: sut.configuration))
        ]

        // When
        try data.forEach {
            // Then
            XCTAssertEqual(try mut($0.input), $0.output)
        }
    }

    func testImperialSaltwater() throws {
        // Given
        sut = .init(.imperial, water: .salt)
        mut = sut.atmospheresAbsolute(at:)
        data = [
            .init(input: 0.0, output: .init(value: 1, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 33, output: .init(value: 2, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 66, output: .init(value: 3, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 99, output: .init(value: 4, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 132, output: .init(value: 5, unit: .atmospheres, configuration: sut.configuration)),
            .init(input: 87, output: .init(value: 3.6363636363636362, unit: .atmospheres, configuration: sut.configuration))
        ]

        // When
        try data.forEach {
            // Then
            XCTAssertEqual(try mut($0.input), $0.output)
        }
    }
}
