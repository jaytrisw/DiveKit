import XCTest
@testable import DiveKit

final class BuoyancyCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<BuoyancyCalculator> {

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

    func testBuoyancyInvalidWeightInput() {
        // Given
        let weight: Mass = -209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)

        // When
        XCTAssertThrowsError(try sut.buoyancy(of: object), as: Error<Object>.self) { error in
            // Then
            XCTAssertEqual(error.value, object)
            XCTAssertEqual(error.message.key, "dive.kit.buoyancy.calculator.invalid.object")
            XCTAssertEqual(error.callSite, "BuoyancyCalculator.buoyancy(of:)")
        }
    }

    func testBuoyancyInvalidVolumeInput() {
        // Given
        let weight: Mass = 209
        let volume: Volume = -200
        let object: Object = .init(weight: weight, volume: volume)

        // When
        XCTAssertThrowsError(try sut.buoyancy(of: object), as: Error<Object>.self) { error in
            // Then
            XCTAssertEqual(error.value, object)
            XCTAssertEqual(error.message.key, "dive.kit.buoyancy.calculator.invalid.object")
            XCTAssertEqual(error.callSite, "BuoyancyCalculator.buoyancy(of:)")
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

    func testBuoyancyOfObjectInvalidWeightInput() {
        // Given
        let weight: Mass = -51
        let volume: Volume = 50

        // When
        XCTAssertThrowsError(
            try sut.buoyancyOfObject(
                weighing: weight,
                andDisplacing: volume),
            as: Error<Mass>.self) { error in
                // Then
                XCTAssertEqual(error.value, weight)
                XCTAssertEqual(error.message.key, "dive.kit.buoyancy.calculator.negative.weight")
                XCTAssertEqual(error.callSite, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")
            }
    }

    func testBuoyancyOfObjectInvalidVolumeInput() {
        // Given
        let weight: Mass = 51
        let volume: Volume = -50

        // When
        XCTAssertThrowsError(
            try sut.buoyancyOfObject(
                weighing: weight,
                andDisplacing: volume),
            as: Error<Volume>.self) { error in
                // Then
                XCTAssertEqual(error.value, volume)
                XCTAssertEqual(error.message.key, "dive.kit.buoyancy.calculator.negative.volume")
                XCTAssertEqual(error.callSite, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")
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

    func testVolumeOfObjectWithInvalidInput() {
        // Given
        let weight: Mass = -75
        let buoyancy: Buoyancy = .negative(20)

        // When
        // When
        XCTAssertThrowsError(
            try sut.volumeOfObject(
                weighing: weight,
                with: buoyancy),
            as: Error<Mass>.self) { error in
                // Then
                XCTAssertEqual(error.value, weight)
                XCTAssertEqual(error.message.key, "dive.kit.buoyancy.calculator.negative.weight")
                XCTAssertEqual(error.callSite, "BuoyancyCalculator.volumeOfObject(weighing:with:)")
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
