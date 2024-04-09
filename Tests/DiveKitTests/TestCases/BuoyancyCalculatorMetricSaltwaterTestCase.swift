import XCTest
@testable import DiveKit

final class BuoyancyCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<BuoyancyCalculator> {

    var expectedError: Error!

    // MARK: buoyancy(of:)

    func testBuoyancyValidInput() {
        // Given
        let weight: Mass = 209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)

        // When
        XCTAssertCalculation(try sut.buoyancy(of: object)) { result, configuration in
            // Then
            XCTAssertEqual(result, .negative(3))
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testBuoyancyValidInputNeutral() {
        // Given
        let weight: Mass = 309
        let volume: Volume = 300
        let object: Object = .init(weight: weight, volume: volume)

        // When
        XCTAssertCalculation(try sut.buoyancy(of: object)) { result, configuration in
            // Then
            XCTAssertEqual(result, .neutral)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testBuoyancyInvalidWeightInput() throws {
        // Given
        let weight: Mass = -209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)
        expectedError = .input(.invalid(.object(object)), "BuoyancyCalculator.buoyancy(of:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "invalid.object")
            }
    }

    func testBuoyancyInvalidVolumeInput() throws {
        // Given
        let weight: Mass = 209
        let volume: Volume = -200
        let object: Object = .init(weight: weight, volume: volume)
        expectedError = .input(.invalid(.object(object)), "BuoyancyCalculator.buoyancy(of:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "invalid.object")
            }
    }

    // MARK: buoyancyOfObject(weighing:andDisplacing:)

    func testBuoyancyOfObjectValidInput() {
        // Given
        let weight: Mass = 51
        let volume: Volume = 50

        // When
        XCTAssertCalculation(
            try sut.buoyancyOfObject(
                weighing: weight,
                andDisplacing: volume)) { result, configuration in
                    // Then
                    XCTAssertEqual(result, .positive(0.5))
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testBuoyancyOfObjectInvalidWeightInput() throws {
        // Given
        let weight: Mass = -51
        let volume: Volume = 50
        expectedError = .input(.negative(.weight(weight)), "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.weight")
            }
    }

    func testBuoyancyOfObjectInvalidVolumeInput() throws {
        // Given
        let weight: Mass = 51
        let volume: Volume = -50
        expectedError = .input(.negative(.volume(volume)), "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.volume")
            }
    }

    // MARK: volumeOfObject(weighing:with:)

    func testVolumeOfObjectWithValidInput() {
        // Given
        let weight: Mass = 75
        let buoyancy: Buoyancy = .negative(20)

        // When
        XCTAssertCalculation(
            try sut.volumeOfObject(
                weighing: weight,
                with: buoyancy)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 53.398058252427184)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testVolumeOfObjectWithInvalidInput() throws {
        // Given
        let weight: Mass = -75
        let buoyancy: Buoyancy = .negative(20)
        expectedError = .input(.negative(.weight(weight)), "BuoyancyCalculator.volumeOfObject(weighing:with:)")

        // When
        try XCTAssertThrowsError(
            when: sut.volumeOfObject(weighing: weight, with: buoyancy),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.weight")
            }
    }

    func testVolumeOfObjectAlternateWithValidInput() {
        // Given
        let weight: Mass = 75
        let buoyancy: Buoyancy = .positive(20)

        // When
        XCTAssertCalculation(
            try sut.volumeOfObject(
                weighing: weight,
                with: buoyancy)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 92.23300970873787)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
    }
}
