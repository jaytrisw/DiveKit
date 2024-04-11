import XCTest
@testable import DiveKit

final class BlendUnblendedTestCase: SystemUnderTestCase<Blend<Unblended>> {

    var expectedError: Error!

    func testAddWithValidInput() throws {
        // Given
        let oxygenFraction = 0.8
        let partialPressure: PartialPressure = .init(.oxygen, fractionalPressure: oxygenFraction)

        // When
        try sut.add(partialPressure)

        // Then
        XCTAssertEqual(sut.storage.count, 1)
        XCTAssertEqual(sut.storage.first?.key, Oxygen())
        XCTAssertEqual(sut.storage.first?.value, oxygenFraction)
    }

    func testAddWithInvalidLowerBound() throws {
        // Given
        let oxygenFraction = -0.8
        let partialPressure: PartialPressure = .init(.oxygen, fractionalPressure: oxygenFraction)
        expectedError = .input(.blend(.pressureRange(oxygenFraction, sut)), "Blend<Unblended>.add(_:pressure:)")

        // When
        try XCTAssertThrowsError(
            when: sut.add(partialPressure),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "blend.pressure.range")
            }
    }

    func testAddWithInvalidUpperBound() throws {
        // Given
        let oxygenFraction = 1.01
        let partialPressure: PartialPressure = .init(.oxygen, fractionalPressure: oxygenFraction)
        expectedError = .input(.blend(.pressureRange(oxygenFraction, sut)), "Blend<Unblended>.add(_:pressure:)")

        // When
        try XCTAssertThrowsError(
            when: sut.add(partialPressure),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "blend.pressure.range")
            }
    }

    func testAddingWithValidInput() throws {
        // Given
        let oxygenFraction = 0.8
        let partialPressure: PartialPressure = .init(.oxygen, fractionalPressure: oxygenFraction)

        // When
        let result = try sut.adding(partialPressure)

        // Then
        XCTAssertEqual(result.storage.count, 1)
        XCTAssertEqual(result.storage.first?.key, Oxygen())
        XCTAssertEqual(result.storage.first?.value, oxygenFraction)
    }

    func testFillWithValidInput() throws {
        // Given
        let oxygen = Oxygen()

        // When
        try sut.fill(with: oxygen)

        // Then
        XCTAssertEqual(sut.storage.count, 1)
        XCTAssertEqual(sut.storage.first?.key, Oxygen())
        XCTAssertEqual(sut.storage.first?.value, 1)
    }

    func testFillingWithValidInput() throws {
        // Given
        let oxygen = Oxygen()

        // When
        let result = try sut.filling(with: oxygen)

        // Then
        XCTAssertEqual(result.storage.count, 1)
        XCTAssertEqual(result.storage.first?.key, Oxygen())
        XCTAssertEqual(result.storage.first?.value, 1)
    }

    func testBlendWithValidInput() throws {
        // Given
        let oxygen = Oxygen()
        try sut.fill(with: oxygen)

        // When
        let result = try sut.blend()

        // Then
        XCTAssertEqual(result.storage.count, 1)
        XCTAssertEqual(result.storage.first?.key, Oxygen())
        XCTAssertEqual(result.storage.first?.value, 1)
    }

    func testBlendWithInvalidInput() throws {
        // Given
        let oxygen = Oxygen()
        let oxygenFraction = 0.1
        try sut.add(oxygen, pressure: oxygenFraction)
        expectedError = .input(.blend(.totalPressure(oxygenFraction, sut)), "Blend<Unblended>.blend()")

        // When
        try XCTAssertThrowsError(
            when: sut.blend(),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "blend.total.pressure")
            }
    }

    func testInitializeWithPartialPressures() throws {
        // Given
        let oxygen = PartialPressure(.oxygen, fractionalPressure: 0.40)
        let nitrogen = PartialPressure(.nitrogen, fractionalPressure: 0.60)
        sut = .init(oxygen, nitrogen)

        // When
        let result = try sut.blend()

        // Then
        XCTAssertEqual(result.partialPressure(of: .oxygen), oxygen)
        XCTAssertEqual(result.partialPressure(of: .nitrogen), nitrogen)
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.storage.count, 2)
    }

    func testInitializeWithResultBuilder() throws {
        // Given
        let oxygen = PartialPressure(.oxygen, fractionalPressure: 0.40)
        let nitrogen = PartialPressure(.nitrogen, fractionalPressure: 0.60)

        // When
        sut = .init {
            oxygen

            nitrogen
        }

        // Then
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.storage.count, 2)
    }

    override func createSUT() {
        sut = .init()
    }
}
