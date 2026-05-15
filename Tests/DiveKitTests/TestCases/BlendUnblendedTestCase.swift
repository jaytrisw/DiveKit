import XCTest
@testable @_spi(unsafe) import DiveKit

final class BlendUnblendedTestCase: SystemUnderTestCase<Blend<Unblended>> {

    var expectedError: Error!

    func testAddWithValidInput() throws {
        // Given
        let oxygenFraction = 0.8
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: oxygenFraction)

        // When
        try sut.add(fractionalPressure)

        // Then
        XCTAssertEqual(sut.components().count, 1)
        XCTAssertEqual(sut.fractionalPressure(of: .oxygen), oxygenFraction)
    }

    func testAddWithInvalidLowerBound_consumingUnsafeAPI() throws {
        // Given
        let oxygenFraction = -0.8
        let fractionalPressure = FractionalPressure(.oxygen, fractionalPressure: oxygenFraction)
        expectedError = .blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.add(_:pressure:)")

        // When
        try XCTAssertThrowsError(
            when: sut.add(fractionalPressure),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.blend.pressure.range")
            }
    }

    func testAddWithInvalidUpperBound_consumingUnsafeAPI() throws {
        // Given
        let oxygenFraction = 1.01
        let fractionalPressure = FractionalPressure(.oxygen, fractionalPressure: oxygenFraction)
        expectedError = .blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.add(_:pressure:)")

        // When
        try XCTAssertThrowsError(
            when: sut.add(fractionalPressure),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.blend.pressure.range")
            }
    }

    func testAddingWithValidInput() throws {
        // Given
        let oxygenFraction = 0.8
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: oxygenFraction)

        // When
        let result = try sut.adding(fractionalPressure)

        // Then
        XCTAssertEqual(result.components().count, 1)
        XCTAssertEqual(result.fractionalPressure(of: .oxygen), oxygenFraction)
    }

    func testUpdateWithValidInput() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        try sut.update(.oxygen, pressure: updatedOxygenFraction)

        // Then
        XCTAssertEqual(sut.components().count, 1)
        XCTAssertEqual(sut.fractionalPressure(of: .oxygen), updatedOxygenFraction)
    }

    func testUpdateWithFractionalPressure() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: updatedOxygenFraction)
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        try sut.update(fractionalPressure)

        // Then
        XCTAssertEqual(sut.components().count, 1)
        XCTAssertEqual(sut.fractionalPressure(of: .oxygen), updatedOxygenFraction)
    }

    func testUpdateWithInvalidInput() throws {
        // Given
        let oxygenFraction = 1.01
        expectedError = .blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.update(_:pressure:)")

        // When
        try XCTAssertThrowsError(
            when: sut.update(.oxygen, pressure: oxygenFraction),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.blend.pressure.range")
            }
    }

    func testUpdatingWithValidInput() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        let result = try sut.updating(.oxygen, pressure: updatedOxygenFraction)

        // Then
        XCTAssertEqual(sut.fractionalPressure(of: .oxygen), initialOxygenFraction)
        XCTAssertEqual(result.components().count, 1)
        XCTAssertEqual(result.fractionalPressure(of: .oxygen), updatedOxygenFraction)
    }

    func testUpdatingWithFractionalPressure() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: updatedOxygenFraction)
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        let result = try sut.updating(fractionalPressure)

        // Then
        XCTAssertEqual(sut.fractionalPressure(of: .oxygen), initialOxygenFraction)
        XCTAssertEqual(result.components().count, 1)
        XCTAssertEqual(result.fractionalPressure(of: .oxygen), updatedOxygenFraction)
    }

    func testFillWithValidInput() throws {
        // Given
        let oxygen = Oxygen()

        // When
        try sut.fill(with: oxygen)

        // Then
        XCTAssertEqual(sut.components().count, 1)
        XCTAssertEqual(sut.fractionalPressure(of: .oxygen), 1)
    }

    func testFillingWithValidInput() throws {
        // Given
        let oxygen = Oxygen()

        // When
        let result = try sut.filling(with: oxygen)

        // Then
        XCTAssertEqual(result.components().count, 1)
        XCTAssertEqual(result.fractionalPressure(of: .oxygen), 1)
        XCTAssertTrue(result.components().first.forceUnwrap().isEqual(to: .oxygen))
    }

    func testBlendWithValidInput() throws {
        // Given
        let oxygen = Oxygen()
        try sut.fill(with: oxygen)

        // When
        let result = try sut.blend()

        // Then
        XCTAssertEqual(result.components().count, 1)
        XCTAssertEqual(result.fractionalPressure(of: .oxygen), 1)
    }

    func testBlendWithInvalidInput() throws {
        // Given
        let oxygen = Oxygen()
        let oxygenFraction = 0.1
        try sut.add(oxygen, pressure: oxygenFraction)
        expectedError = .blend(.totalPressure(oxygenFraction, sut), "Blend<Unblended>.blend()")

        // When
        try XCTAssertThrowsError(
            when: sut.blend(),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.blend.total.pressure")
            }
    }

    func testInitializeWithFractionalPressures() throws {
        // Given
        let oxygen = try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)
        let nitrogen = try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        sut = .init(oxygen, nitrogen)

        // When
        let result = try sut.blend()

        // Then
        XCTAssertEqual(try result.fractionalPressure(of: .oxygen), oxygen)
        XCTAssertEqual(try result.fractionalPressure(of: .nitrogen), nitrogen)
        XCTAssertEqual(result.totalPressure, 1.0)
        XCTAssertEqual(result.components().count, 2)
    }

    func testInitializeWithResultBuilder() throws {
        // When
        sut = try .init { () throws(DiveKit.Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)

            try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        }

        // Then
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.components().count, 2)
    }

    func testInitializeWithResultBuilder_consumingUnsafeAPI() throws {
        // Given
        let oxygen = FractionalPressure(.oxygen, fractionalPressure: 0.40)
        let nitrogen = FractionalPressure(.nitrogen, fractionalPressure: 0.60)

        // When
        sut = .init {
            oxygen

            nitrogen
        }

        // Then
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.components().count, 2)
    }

    override func createSUT() {
        sut = .init()
    }
}
