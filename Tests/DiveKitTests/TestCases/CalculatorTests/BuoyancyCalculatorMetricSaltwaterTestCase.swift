import Testing
@testable import DiveKit

final class BuoyancyCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<BuoyancyCalculator> {

    var expectedError: Error!

    // MARK: buoyancy(of:)

    @Test
    func testBuoyancyValidInput() throws {
        // Given
        let weight: Mass = 209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)

        // When
        try expectCalculation(
            sut.buoyancy(of: object)) { result, configuration in
                // Then
                #expect(result == .negative(3))
                #expect(configuration == sut.configuration)
        }
    }

    @Test
    func testBuoyancyValidInputNeutral() throws {
        // Given
        let weight: Mass = 309
        let volume: Volume = 300
        let object: Object = .init(weight: weight, volume: volume)

        // When
        try expectCalculation(
            sut.buoyancy(of: object)) { result, configuration in
                // Then
                #expect(result == .neutral)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testBuoyancyInvalidWeightInput() throws {
        // Given
        let weight: Mass = -209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)
        expectedError = .negative(weight, "BuoyancyCalculator.buoyancy(of:)")

        // When
        try expectThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.weight")
            }
    }

    @Test
    func testBuoyancyInvalidVolumeInput() throws {
        // Given
        let weight: Mass = 209
        let volume: Volume = -200
        let object: Object = .init(weight: weight, volume: volume)
        expectedError = .negative(volume, "BuoyancyCalculator.buoyancy(of:)")

        // When
        try expectThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.volume")
            }
    }

    // MARK: buoyancyOfObject(weighing:andDisplacing:)

    @Test
    func testBuoyancyOfObjectValidInput() throws {
        // Given
        let weight: Mass = 51
        let volume: Volume = 50

        // When
        try expectCalculation(
            sut.buoyancyOfObject(
                weighing: weight,
                andDisplacing: volume)) { result, configuration in
                    // Then
                    #expect(result == .positive(0.5))
                    #expect(configuration == sut.configuration)
                }
    }

    @Test
    func testBuoyancyOfObjectInvalidWeightInput() throws {
        // Given
        let weight: Mass = -51
        let volume: Volume = 50
        expectedError = .negative(weight, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")

        // When
        try expectThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.weight")
            }
    }

    @Test
    func testBuoyancyOfObjectInvalidVolumeInput() throws {
        // Given
        let weight: Mass = 51
        let volume: Volume = -50
        expectedError = .negative(volume, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")

        // When
        try expectThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.volume")
            }
    }

    // MARK: volumeOfObject(weighing:with:)

    @Test
    func testVolumeOfObjectWithValidInput() throws {
        // Given
        let weight: Mass = 75
        let buoyancy: Buoyancy = .negative(20)

        // When
        try expectCalculation(
            sut.volumeOfObject(
                weighing: weight,
                with: buoyancy)) { result, configuration in
                    // Then
                    #expect(result.value == 53.398058252427184)
                    #expect(configuration == sut.configuration)
                }
    }

    @Test
    func testVolumeOfObjectWithInvalidInput() throws {
        // Given
        let weight: Mass = -75
        let buoyancy: Buoyancy = .negative(20)
        expectedError = .negative(weight, "BuoyancyCalculator.volumeOfObject(weighing:with:)")

        // When
        try expectThrowsError(
            when: sut.volumeOfObject(weighing: weight, with: buoyancy),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.weight")
            }
    }

    @Test
    func testVolumeOfObjectAlternateWithValidInput() throws {
        // Given
        let weight: Mass = 75
        let buoyancy: Buoyancy = .positive(20)

        // When
        try expectCalculation(
            sut.volumeOfObject(
                weighing: weight,
                with: buoyancy)) { result, configuration in
                    // Then
                    #expect(result.value == 92.23300970873787)
                    #expect(configuration == sut.configuration)
                }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
    }
}
