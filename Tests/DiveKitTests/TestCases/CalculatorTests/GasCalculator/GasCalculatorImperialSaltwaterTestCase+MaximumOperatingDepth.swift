import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: maximumOperatingDepth(for:in:)

    func testMaximumOperatingDepthForEAN28AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.28)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 131.99999719006675, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN30AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.30)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 120.99999737739564, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN32AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.32)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 111.3749975413084, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN34AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.34)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 102.88235062711377, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN36AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.36)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 95.3333311478297, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN40AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.40)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 82.49999803304672, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN28AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.28)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 155.5714313813618, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN30AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.30)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 143.00000262260437, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN32AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.32)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 132.0000024586916, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN34AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.34)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 122.29411996112148, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN36AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.36)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 113.6666688521703, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForEAN40AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.40)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 99.00000196695328, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForAirAtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = Blend<Blended>.air

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 188.0526278144435, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthForAirAtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = Blend<Blended>.air

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 219.6315827118723, accuracy: 0.0001)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthRejectsNegativeOxygenPartialPressure() throws {
        let partialPressure: PartialPressure<Oxygen> = -1.4
        let blend = try Blend<Blended>.enrichedAir(0.32)
        expectedError = .negative(partialPressure, "GasCalculator.maximumOperatingDepth(for:in:)")

        // When
        try XCTAssertThrowsError(
            when: sut.maximumOperatingDepth(for: partialPressure, in: blend),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.negative.partial.pressure")
            }
    }

    func testMaximumOperatingDepthRejectsBlendWithZeroOxygen() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4

        let blend = try Blend<Blended> { () throws(DiveKit.Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: 0.0)
            try FractionalPressure(of: .nitrogen, fractionalPressure: 1.0)
        }

        expectedError = .range(
            .lowerBound(0, 0),
            "GasCalculator.maximumOperatingDepth(for:in:)")

        // When / Then
        try XCTAssertThrowsError(
            when: sut.maximumOperatingDepth(for: partialPressure, in: blend),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.range.lower.bound")
            }
    }

    func testMaximumOperatingDepthRejectsZeroOxygenPartialPressure() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 0
        let blend = try Blend<Blended>.enrichedAir(0.32)

        expectedError = .range(
            .lowerBound(0, 0),
            "GasCalculator.maximumOperatingDepth(for:in:)")

        // When / Then
        try XCTAssertThrowsError(
            when: sut.maximumOperatingDepth(for: partialPressure, in: blend),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.range.lower.bound")
            }
    }
}
