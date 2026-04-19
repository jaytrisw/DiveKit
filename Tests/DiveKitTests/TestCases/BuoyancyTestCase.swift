import Testing
@testable import DiveKit

final class BuoyancyTestCase: SystemUnderTestCase<Buoyancy> {

    @Test
    func testInitializerWithZero() {
        // Given
        let value: Double = .zero

        // When
        sut = .init(value)

        // Then
        #expect(sut == .neutral)
    }

    @Test
    func testInitializerWithPositiveValue() {
        // Given
        let value: Double = .random(in: 1 ... 100)

        // When
        sut = .init(value)

        // Then
        #expect(sut == .positive(value))
    }

    @Test
    func testInitializerWithNegativeValue() {
        // Given
        let value: Double = .random(in: -100 ... -1)

        // When
        sut = .init(value)

        // Then
        #expect(sut == .negative(abs(value)))
    }
}
