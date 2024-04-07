import XCTest
@testable import DiveKit

final class AtmospheresAbsoluteTestCaseTest: ThrowingMethodUnderTestCase<PhysicsCalculator, Depth, Calculation<Double.Result<Pressure.Unit>>> {

    func testMetricSaltwater() throws {
        // Given
        sut = .init(.metric, water: .salt)
        mut = sut.atmospheresAbsolute(at:)
        data = [
            .init(0.0, output: .double(1, unit: .atmospheres, configuration: sut.configuration)),
            .init(10, output: .double(2, unit: .atmospheres, configuration: sut.configuration)),
            .init(20, output: .double(3, unit: .atmospheres, configuration: sut.configuration)),
            .init(30, output: .double(4, unit: .atmospheres, configuration: sut.configuration)),
            .init(40, output: .double(5, unit: .atmospheres, configuration: sut.configuration)),
            .init(38.5, output: .double(4.85, unit: .atmospheres, configuration: sut.configuration))
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
            .init(0.0, output: .double(1, unit: .atmospheres, configuration: sut.configuration)),
            .init(33, output: .double(2, unit: .atmospheres, configuration: sut.configuration)),
            .init(66, output: .double(3, unit: .atmospheres, configuration: sut.configuration)),
            .init(99, output: .double(4, unit: .atmospheres, configuration: sut.configuration)),
            .init(132, output: .double(5, unit: .atmospheres, configuration: sut.configuration)),
            .init(87, output: .double(3.6363636363636362, unit: .atmospheres, configuration: sut.configuration))
        ]

        // When
        try data.forEach {
            // Then
            XCTAssertEqual(try mut($0.input), $0.output)
        }
    }
}
