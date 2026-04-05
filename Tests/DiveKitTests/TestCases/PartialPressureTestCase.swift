import XCTest
@testable import DiveKit

final class PartialPressureTestCase: XCTestCase {

    func testInitializationStoresValidFractionalPressure() throws {
        // Given
        let gas = Oxygen()

        // When
        let sut = try FractionalPressure(of: gas, fractionalPressure: 0.21)

        // Then
        XCTAssertEqual(sut.gas, gas)
        XCTAssertEqual(sut.fractionalPressure, 0.21)
    }

    func testInitializationRejectsNegativeFractionalPressure() throws {
        // Given
        let gas = Oxygen()
        let fractionalPressure = -0.01
        let expectedError: Error = .negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try XCTAssertThrowsError(
            when: try FractionalPressure(of: gas, fractionalPressure: fractionalPressure),
            then: expectedError) { error in
                XCTAssertEqual(error.localizationKey, "dive.kit.error.negative.fractional.pressure")
            }
    }

    func testInitializationRejectsFractionalPressureGreaterThanOne() throws {
        // Given
        let gas = Oxygen()
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, 1),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try XCTAssertThrowsError(
            when: try FractionalPressure(of: gas, fractionalPressure: fractionalPressure),
            then: expectedError) { error in
                XCTAssertEqual(error.localizationKey, "dive.kit.error.range.upper.bound")
            }
    }
}
