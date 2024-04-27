import XCTest
@testable import DiveKit

final class BuoyancyTestCase: SystemUnderTestCase<Buoyancy> {

    func testInitializerWithZero() {
        // Given
        let value: Double = .zero

        // When
        sut = .init(value)

        // Then
        XCTAssertEqual(sut, .neutral)
    }

    func testInitializerWithPositiveValue() {
        // Given
        let value: Double = .random(in: 1 ... 100)

        // When
        sut = .init(value)

        // Then
        XCTAssertEqual(sut, .positive(value))
    }

    func testInitializerWithNegativeValue() {
        // Given
        let value: Double = .random(in: -100 ... -1)

        // When
        sut = .init(value)

        // Then
        XCTAssertEqual(sut, .negative(abs(value)))
    }
}
