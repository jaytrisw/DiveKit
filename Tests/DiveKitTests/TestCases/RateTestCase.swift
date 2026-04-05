import XCTest
@testable import DiveKit

final class RateTestCase: SystemUnderTestCase<Rate<Pressure>> {
    func testInit() {
        // Given
        let expected: Double = 15

        // When
        sut = .init(expected)

        // Then
        XCTAssertEqual(sut.value, expected)
    }

    func testEquatable() {
        // Given
        let lhs: Rate<Pressure> = 15
        let rhs: Rate<Pressure> = 15

        // Then
        XCTAssertEqual(lhs, rhs)
    }

    func testLocalization() {
        // Given
        sut = 15

        // When
        let result = sut.localization(for: .perMinute(.psi), style: .short)

        // Then
        XCTAssertEqual(result, "15 psi/min")
    }
}
