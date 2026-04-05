import XCTest
@testable import DiveKit

final class RateFormatStyleTestCase: SystemUnderTestCase<Rate<Pressure>> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.rate(.perMinute(.psi), style: .full))

        // Then
        XCTAssertEqual(result, "15 pounds per square inch per minute")
    }
}
