import Testing
@testable @_spi(unsafe) import DiveKit

final class BlendUnblendedTestCase: SystemUnderTestCase<Blend<Unblended>> {

    var expectedError: Error!

    @Test
    func testAddWithValidInput() throws {
        // Given
        let oxygenFraction = 0.8
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: oxygenFraction)

        // When
        try sut.add(fractionalPressure)

        // Then
        #expect(sut.components().count == 1)
        let result = sut.fractionalPressure(of: .oxygen)
        #expect(result == oxygenFraction)
    }

    @Test
    func testAddWithInvalidLowerBound_consumingUnsafeAPI() throws {
        // Given
        let oxygenFraction = -0.8
        let fractionalPressure = FractionalPressure(.oxygen, fractionalPressure: oxygenFraction)
        expectedError = .blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.add(_:pressure:)")

        // When
        try expectThrowsError(
            when: sut.add(fractionalPressure),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.blend.pressure.range")
            }
    }

    @Test
    func testAddWithInvalidUpperBound_consumingUnsafeAPI() throws {
        // Given
        let oxygenFraction = 1.01
        let fractionalPressure = FractionalPressure(.oxygen, fractionalPressure: oxygenFraction)
        expectedError = .blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.add(_:pressure:)")

        // When
        try expectThrowsError(
            when: sut.add(fractionalPressure),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.blend.pressure.range")
            }
    }

    @Test
    func testAddingWithValidInput() throws {
        // Given
        let oxygenFraction = 0.8
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: oxygenFraction)

        // When
        let result = try sut.adding(fractionalPressure)

        // Then
        #expect(result.components().count == 1)
        let oxygen = result.fractionalPressure(of: .oxygen)
        #expect(oxygen == oxygenFraction)
    }

    @Test
    func testUpdateWithValidInput() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        try sut.update(.oxygen, pressure: updatedOxygenFraction)

        // Then
        #expect(sut.components().count == 1)
        let result = sut.fractionalPressure(of: .oxygen)
        #expect(result == updatedOxygenFraction)
    }

    @Test
    func testUpdateWithFractionalPressure() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: updatedOxygenFraction)
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        try sut.update(fractionalPressure)

        // Then
        #expect(sut.components().count == 1)
        let result = sut.fractionalPressure(of: .oxygen)
        #expect(result == updatedOxygenFraction)
    }

    @Test
    func testUpdateWithInvalidInput() throws {
        // Given
        let oxygenFraction = 1.01
        expectedError = .blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.update(_:pressure:)")

        // When
        try expectThrowsError(
            when: sut.update(.oxygen, pressure: oxygenFraction),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.blend.pressure.range")
            }
    }

    @Test
    func testUpdatingWithValidInput() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        let result = try sut.updating(.oxygen, pressure: updatedOxygenFraction)

        // Then
        let initialOxygen = sut.fractionalPressure(of: .oxygen)
        #expect(initialOxygen == initialOxygenFraction)
        #expect(result.components().count == 1)
        let updatedOxygen = result.fractionalPressure(of: .oxygen)
        #expect(updatedOxygen == updatedOxygenFraction)
    }

    @Test
    func testUpdatingWithFractionalPressure() throws {
        // Given
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: updatedOxygenFraction)
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        // When
        let result = try sut.updating(fractionalPressure)

        // Then
        let initialOxygen = sut.fractionalPressure(of: .oxygen)
        #expect(initialOxygen == initialOxygenFraction)
        #expect(result.components().count == 1)
        let updatedOxygen = result.fractionalPressure(of: .oxygen)
        #expect(updatedOxygen == updatedOxygenFraction)
    }

    @Test
    func testFillWithValidInput() throws {
        // Given
        let oxygen = Oxygen()

        // When
        try sut.fill(with: oxygen)

        // Then
        #expect(sut.components().count == 1)
        let result = sut.fractionalPressure(of: .oxygen)
        #expect(result == 1)
    }

    @Test
    func testFillingWithValidInput() throws {
        // Given
        let oxygen = Oxygen()

        // When
        let result = try sut.filling(with: oxygen)

        // Then
        #expect(result.components().count == 1)
        let oxygenFraction = result.fractionalPressure(of: .oxygen)
        #expect(oxygenFraction == 1)
        #expect(result.components().first.forceUnwrap().isEqual(to: .oxygen))
    }

    @Test
    func testBlendWithValidInput() throws {
        // Given
        let oxygen = Oxygen()
        try sut.fill(with: oxygen)

        // When
        let result = try sut.blend()

        // Then
        #expect(result.components().count == 1)
        let oxygenFraction = try result.fractionalPressure(of: .oxygen)
        #expect(oxygenFraction.value == 1)
    }

    @Test
    func testBlendWithInvalidInput() throws {
        // Given
        let oxygen = Oxygen()
        let oxygenFraction = 0.1
        try sut.add(oxygen, pressure: oxygenFraction)
        expectedError = .blend(.totalPressure(oxygenFraction, sut), "Blend<Unblended>.blend()")

        // When
        try expectThrowsError(
            when: sut.blend(),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.blend.total.pressure")
            }
    }

    @Test
    func testInitializeWithFractionalPressures() throws {
        // Given
        let oxygen = try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)
        let nitrogen = try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        sut = .init(oxygen, nitrogen)

        // When
        let result = try sut.blend()

        // Then
        let resultOxygen = try result.fractionalPressure(of: .oxygen)
        let resultNitrogen = try result.fractionalPressure(of: .nitrogen)
        #expect(resultOxygen == oxygen)
        #expect(resultNitrogen == nitrogen)
        #expect(result.totalPressure == 1.0)
        #expect(result.components().count == 2)
    }

    @Test
    func testInitializeWithResultBuilder() throws {
        // When
        sut = try .init { () throws(DiveKit.Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)

            try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        }

        // Then
        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    @Test
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
        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    override func createSUT() {
        sut = .init()
    }
}
