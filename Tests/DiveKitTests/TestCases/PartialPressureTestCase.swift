import XCTest
@testable import DiveKit

final class PartialPressureTestCase: XCTestCase {

    func testInitializationStoresValidFractionalPressure() throws {
        // Given
        let gas = Oxygen()

        // When
        let sut = try PartialPressure(of: gas, fractionalPressure: 0.21)

        // Then
        XCTAssertEqual(sut.gas, gas)
        XCTAssertEqual(sut.fractionalPressure, 0.21)
    }

    func testInitializationRejectsNegativeFractionalPressure() throws {
        // Given
        let gas = Oxygen()
        let fractionalPressure = -0.01
        let expectedError: Error = .range(
            .lowerBound(fractionalPressure, 0),
            "PartialPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try XCTAssertThrowsError(
            when: try PartialPressure(of: gas, fractionalPressure: fractionalPressure),
            then: expectedError
        )
    }

    func testInitializationRejectsFractionalPressureGreaterThanOne() throws {
        // Given
        let gas = Oxygen()
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, 1),
            "PartialPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try XCTAssertThrowsError(
            when: try PartialPressure(of: gas, fractionalPressure: fractionalPressure),
            then: expectedError
        )
    }
}
