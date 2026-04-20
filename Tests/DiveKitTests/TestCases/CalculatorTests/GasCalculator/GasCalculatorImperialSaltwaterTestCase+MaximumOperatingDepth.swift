import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: maximumOperatingDepth(for:in:)

    @Test
    func testMaximumOperatingDepthForEAN28AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.28)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 131.99999719006675) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN30AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.30)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 120.99999737739564) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN32AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.32)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 111.3749975413084) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN34AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.34)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 102.88235062711377) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN36AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.36)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 95.3333311478297) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN40AtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = try Blend<Blended>.enrichedAir(0.40)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 82.49999803304672) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN28AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.28)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 155.5714313813618) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN30AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.30)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 143.00000262260437) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN32AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.32)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 132.0000024586916) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN34AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.34)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 122.29411996112148) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN36AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.36)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 113.6666688521703) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForEAN40AtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = try Blend<Blended>.enrichedAir(0.40)

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 99.00000196695328) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForAirAtOnePointFour() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.4
        let blend = Blend<Blended>.air

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 188.0526278144435) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testMaximumOperatingDepthForAirAtOnePointSix() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 1.6
        let blend = Blend<Blended>.air

        // When
        try expectCalculation(
            sut.maximumOperatingDepth(for: partialPressure, in: blend)) { result, configuration in
                // Then
                #expect(abs(result.value - 219.6315827118723) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == sut.configuration)
            }
    }

    @Test(.tags(.error))
    func testMaximumOperatingDepthRejectsNegativeOxygenPartialPressure() throws {
        let partialPressure: PartialPressure<Oxygen> = -1.4
        let blend = try Blend<Blended>.enrichedAir(0.32)
        expectedError = .negative(partialPressure, "GasCalculator.maximumOperatingDepth(for:in:)")

        // When
        try expectThrowsError(
            when: sut.maximumOperatingDepth(for: partialPressure, in: blend),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.partial.pressure")
            }
    }

    @Test(.tags(.error))
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
        try expectThrowsError(
            when: sut.maximumOperatingDepth(for: partialPressure, in: blend),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.range.lower.bound")
            }
    }

    @Test(.tags(.error))
    func testMaximumOperatingDepthRejectsZeroOxygenPartialPressure() throws {
        // Given
        let partialPressure: PartialPressure<Oxygen> = 0
        let blend = try Blend<Blended>.enrichedAir(0.32)

        expectedError = .range(
            .lowerBound(0, 0),
            "GasCalculator.maximumOperatingDepth(for:in:)")

        // When / Then
        try expectThrowsError(
            when: sut.maximumOperatingDepth(for: partialPressure, in: blend),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.range.lower.bound")
            }
    }
}
