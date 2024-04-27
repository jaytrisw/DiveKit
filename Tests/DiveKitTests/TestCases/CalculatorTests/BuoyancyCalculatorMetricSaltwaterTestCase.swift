import XCTest
@testable import DiveKit

final class BuoyancyCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<BuoyancyCalculator> {

    var expectedError: Error!

    // MARK: buoyancy(of:)

    func testBuoyancyValidInput() throws {
        // Given
        let weight: Mass = 209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)

        // When
        try XCTAssertCalculation(
            sut.buoyancy(of: object)) { result, configuration in
                // Then
                XCTAssertEqual(result, .negative(3))
                XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testBuoyancyValidInputNeutral() throws {
        // Given
        let weight: Mass = 309
        let volume: Volume = 300
        let object: Object = .init(weight: weight, volume: volume)

        // When
        try XCTAssertCalculation(
            sut.buoyancy(of: object)) { result, configuration in
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
        expectedError = .negative(weight, "BuoyancyCalculator.buoyancy(of:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.weight")
            }
    }

    func testBuoyancyInvalidVolumeInput() throws {
        // Given
        let weight: Mass = 209
        let volume: Volume = -200
        let object: Object = .init(weight: weight, volume: volume)
        expectedError = .negative(volume, "BuoyancyCalculator.buoyancy(of:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.volume")
            }
    }

    // MARK: buoyancyOfObject(weighing:andDisplacing:)

    func testBuoyancyOfObjectValidInput() throws {
        // Given
        let weight: Mass = 51
        let volume: Volume = 50

        // When
        try XCTAssertCalculation(
            sut.buoyancyOfObject(
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
        expectedError = .negative(weight, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.weight")
            }
    }

    func testBuoyancyOfObjectInvalidVolumeInput() throws {
        // Given
        let weight: Mass = 51
        let volume: Volume = -50
        expectedError = .negative(volume, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")

        // When
        try XCTAssertThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.volume")
            }
    }

    // MARK: volumeOfObject(weighing:with:)

    func testVolumeOfObjectWithValidInput() throws {
        // Given
        let weight: Mass = 75
        let buoyancy: Buoyancy = .negative(20)

        // When
        try XCTAssertCalculation(
            sut.volumeOfObject(
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
        expectedError = .negative(weight, "BuoyancyCalculator.volumeOfObject(weighing:with:)")

        // When
        try XCTAssertThrowsError(
            when: sut.volumeOfObject(weighing: weight, with: buoyancy),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.weight")
            }
    }

    func testVolumeOfObjectAlternateWithValidInput() throws {
        // Given
        let weight: Mass = 75
        let buoyancy: Buoyancy = .positive(20)

        // When
        try XCTAssertCalculation(
            sut.volumeOfObject(
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
