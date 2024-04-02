import TestUtility
@testable import DiveKitCore

final class BlendBlendedTestCase: SystemUnderTestCase<Blend<Blended>> {

    func testPartialPressure() throws {
        // Given
        let gas = Oxygen()
        sut = try Blend()
            .filling(with: gas)
            .blend()

        // When
        let result = sut.partialPressure(of: gas)

        // Then
        XCTAssertEqual(result.value, 1.0)
        XCTAssertEqual(result.gas, gas)
    }

    func testPartialPressureGasNotInBlend() throws {
        // Given
        let gas = Oxygen()
        sut = try Blend()
            .filling(with: .nitrogen)
            .blend()

        // When
        let result = sut.partialPressure(of: gas)

        // Then
        XCTAssertEqual(result.value, .zero)
        XCTAssertEqual(result.gas, gas)
    }
}
