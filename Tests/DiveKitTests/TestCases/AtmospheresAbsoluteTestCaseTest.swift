import Testing
@testable import DiveKit

final class AtmospheresAbsoluteTestCaseTest: ThrowingMethodUnderTestCase<PhysicsCalculator, Depth, Calculation<DecimalResult<Pressure>>> {

    @Test
    func testMetricSaltwater() throws {
        // Given
        sut = .init(.metric, water: .salt)
        mut = sut.atmospheresAbsolute(at:)
        data = [
            .init(0.0, output: .decimal(1, unit: .atmospheres, configuration: sut.configuration)),
            .init(10, output: .decimal(2, unit: .atmospheres, configuration: sut.configuration)),
            .init(20, output: .decimal(3, unit: .atmospheres, configuration: sut.configuration)),
            .init(30, output: .decimal(4, unit: .atmospheres, configuration: sut.configuration)),
            .init(40, output: .decimal(5, unit: .atmospheres, configuration: sut.configuration)),
            .init(38.5, output: .decimal(4.85, unit: .atmospheres, configuration: sut.configuration))
        ]

        // When
        for value in data {
            let result = try mut(value.input)

            // Then
            #expect(result == value.output)
        }
    }

    @Test
    func testImperialSaltwater() throws {
        // Given
        sut = .init(.imperial, water: .salt)
        mut = sut.atmospheresAbsolute(at:)
        data = [
            .init(0.0, output: .decimal(1, unit: .atmospheres, configuration: sut.configuration)),
            .init(33, output: .decimal(2, unit: .atmospheres, configuration: sut.configuration)),
            .init(66, output: .decimal(3, unit: .atmospheres, configuration: sut.configuration)),
            .init(99, output: .decimal(4, unit: .atmospheres, configuration: sut.configuration)),
            .init(132, output: .decimal(5, unit: .atmospheres, configuration: sut.configuration)),
            .init(87, output: .decimal(3.6363636363636362, unit: .atmospheres, configuration: sut.configuration))
        ]

        // When
        for value in data {
            let result = try mut(value.input)

            // Then
            #expect(result == value.output)
        }
    }
}
